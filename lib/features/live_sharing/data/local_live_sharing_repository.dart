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
    return LiveSharingSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<LiveSharingSession?> pause() async {
    final current = await getCurrentSession();
    if (current == null) {
      return null;
    }
    final next = LiveSharingSession(
      id: current.id,
      minutesRemaining: current.minutesRemaining,
      reason: current.reason,
      isPaused: true,
    );
    await _preferences.setString(_key, jsonEncode(next.toJson()));
    return next;
  }

  @override
  Future<LiveSharingSession> start({required int minutes, String? reason}) async {
    final session = LiveSharingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      minutesRemaining: minutes,
      reason: reason,
      isPaused: false,
    );
    await _preferences.setString(_key, jsonEncode(session.toJson()));
    return session;
  }
}
