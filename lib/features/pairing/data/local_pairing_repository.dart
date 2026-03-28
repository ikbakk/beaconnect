import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
import '../domain/pairing_repository.dart';

class LocalPairingRepository implements PairingRepository {
  LocalPairingRepository(this._preferences);

  static const _pairKey = 'pairing.current_pair';

  final SharedPreferences _preferences;

  @override
  Future<PairRecord?> getCurrentPair() async {
    final raw = _preferences.getString(_pairKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return PairRecord.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<PairRecord> createInviteCode({required AppUser currentUser}) async {
    final pair = PairRecord(
      id: 'pair-draft-1',
      memberIds: [currentUser.id],
      status: 'pending',
      inviteCode: 'BEACON',
      partnerDisplayName: 'Sarah',
      expiresInMinutes: 5,
    );
    await _preferences.setString(_pairKey, jsonEncode(pair.toJson()));
    return pair;
  }

  @override
  Future<PairRecord> approvePairing({
    required AppUser currentUser,
    String? inviteCode,
  }) async {
    final pair = PairRecord(
      id: 'pair-1',
      memberIds: [currentUser.id, 'user-2'],
      status: 'active',
      inviteCode: inviteCode ?? 'BEACON',
      partnerDisplayName: 'Sarah',
      expiresInMinutes: 5,
    );
    await _preferences.setString(_pairKey, jsonEncode(pair.toJson()));
    return pair;
  }

  @override
  Future<void> skipPairing() async {
    await _preferences.remove(_pairKey);
  }
}
