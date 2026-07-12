import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/request_check_in_repository.dart';

class LocalRequestCheckInRepository implements RequestCheckInRepository {
  LocalRequestCheckInRepository(this._preferences);

  static const _lastRequestKey = 'request_check_in.last_sent_at';
  static const _pendingRequestKey = 'request_check_in.pending_request';

  final SharedPreferences _preferences;

  @override
  Future<void> createRequest({
    required DateTime createdAt,
    required String requesterUserId,
    required String requesterName,
    required String partnerUserId,
  }) async {
    await _preferences.setString(_lastRequestKey, createdAt.toIso8601String());
    await _preferences.setString(
      _pendingRequestKey,
      jsonEncode({
        'requesterUserId': requesterUserId,
        'requesterName': requesterName,
        'partnerUserId': partnerUserId,
        'status': 'pending',
        'response': null,
        'createdAt': createdAt.toIso8601String(),
        'respondedAt': null,
      }),
    );
  }

  @override
  Future<DateTime?> getLastRequestAt() async {
    final raw = _preferences.getString(_lastRequestKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  @override
  Future<bool> respondToLatestIncomingRequest({
    required String responderUserId,
    required String response,
  }) async {
    final raw = _preferences.getString(_pendingRequestKey);
    if (raw == null || raw.isEmpty) {
      return false;
    }

    final json = jsonDecode(raw) as Map<String, dynamic>;
    if (json['partnerUserId'] != responderUserId || json['status'] != 'pending') {
      return false;
    }

    json['status'] = 'responded';
    json['response'] = response;
    json['respondedAt'] = DateTime.now().toIso8601String();
    await _preferences.setString(_pendingRequestKey, jsonEncode(json));
    return true;
  }
}
