import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/live_sharing_repository.dart';
import '../domain/live_sharing_session.dart';

class LocalLiveSharingRepository implements LiveSharingRepository {
  LocalLiveSharingRepository(this._preferences);

  static const _key = 'live_sharing.current_session';

  final SharedPreferences _preferences;

  @override
  Future<void> end() async {
    await _preferences.remove(_key);
  }

  @override
  Future<LiveSharingSession?> getCurrentSession() async {
    final raw = _preferences.getString(_key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final current = LiveSharingSession.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    if (current.isExpired) {
      await end();
      return null;
    }

    if (current.isPaused) {
      return current;
    }

    final refreshed = current.copyWith(
      minutesRemaining: _remainingMinutes(current.endsAt),
    );
    await _preferences.setString(_key, jsonEncode(refreshed.toJson()));
    return refreshed;
  }

  @override
  Future<LiveSharingSession?> pause() async {
    final current = await getCurrentSession();
    if (current == null || current.isPaused) {
      return current;
    }

    final pausedAt = DateTime.now();
    final next = current.copyWith(
      isPaused: true,
      pausedAt: pausedAt,
      minutesRemaining: _remainingMinutes(current.endsAt, from: pausedAt),
    );
    await _preferences.setString(_key, jsonEncode(next.toJson()));
    return next;
  }

  @override
  Future<LiveSharingSession?> resume() async {
    final current = await getCurrentSession();
    if (current == null || !current.isPaused) {
      return current;
    }

    final resumedAt = DateTime.now();
    final next = current.copyWith(
      isPaused: false,
      endsAt: resumedAt.add(Duration(minutes: current.minutesRemaining)),
      clearPausedAt: true,
    );
    await _preferences.setString(_key, jsonEncode(next.toJson()));
    return next;
  }

  @override
  Future<LiveSharingSession> start({required int minutes, String? reason}) async {
    final startedAt = DateTime.now();
    final session = LiveSharingSession(
      id: startedAt.millisecondsSinceEpoch.toString(),
      minutesRemaining: minutes,
      reason: reason,
      isPaused: false,
      startedAt: startedAt,
      endsAt: startedAt.add(Duration(minutes: minutes)),
      pausedAt: null,
    );
    await _preferences.setString(_key, jsonEncode(session.toJson()));
    return session;
  }

  int _remainingMinutes(DateTime endsAt, {DateTime? from}) {
    final remainingSeconds = endsAt.difference(from ?? DateTime.now()).inSeconds;
    if (remainingSeconds <= 0) {
      return 0;
    }

    return (remainingSeconds / 60).ceil();
  }
}
