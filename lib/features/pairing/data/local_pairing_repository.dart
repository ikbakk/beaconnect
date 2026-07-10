import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
import '../domain/pairing_failure.dart';
import '../domain/pairing_repository.dart';

class LocalPairingRepository implements PairingRepository {
  LocalPairingRepository(this._preferences);

  static const _pairKey = 'pairing.current_pair';
  static const _inviteCodeKey = 'pairing.pending_invite_code';
  static const _inviteOwnerKey = 'pairing.pending_invite_owner';
  static const _inviteExpiresAtKey = 'pairing.pending_invite_expires_at';

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
    final existingPair = await getCurrentPair();
    final existingInviteCode = _preferences.getString(_inviteCodeKey);
    final existingOwner = _preferences.getString(_inviteOwnerKey);
    final existingExpiresAt = _preferences.getInt(_inviteExpiresAtKey);
    final now = DateTime.now();
    if (existingPair != null &&
        existingPair.status == 'pending' &&
        existingOwner == currentUser.id &&
        existingInviteCode != null &&
        existingExpiresAt != null &&
        DateTime.fromMillisecondsSinceEpoch(existingExpiresAt).isAfter(now)) {
      return existingPair;
    }

    final expiresAt = now.add(const Duration(minutes: 5));
    const inviteCode = 'BEACON';
    final pair = PairRecord(
      id: 'pair-draft-${currentUser.id}',
      memberIds: [currentUser.id],
      status: 'pending',
      inviteCode: inviteCode,
      partnerDisplayName: 'Your partner',
      expiresInMinutes: 5,
    );
    await _preferences.setString(_pairKey, jsonEncode(pair.toJson()));
    await _preferences.setString(_inviteCodeKey, inviteCode);
    await _preferences.setString(_inviteOwnerKey, currentUser.id);
    await _preferences.setInt(
      _inviteExpiresAtKey,
      expiresAt.millisecondsSinceEpoch,
    );
    return pair;
  }

  @override
  Future<PairRecord> approvePairing({
    required AppUser currentUser,
    String? inviteCode,
  }) async {
    final normalizedInviteCode = inviteCode?.trim().toUpperCase() ?? '';
    if (normalizedInviteCode.isEmpty) {
      throw const PairingFailure(
        'Enter your partner\'s code, or pair later for now.',
      );
    }

    final ownInviteCode = _preferences.getString(_inviteCodeKey);
    final ownInviteOwner = _preferences.getString(_inviteOwnerKey);
    final ownInviteExpiresAt = _preferences.getInt(_inviteExpiresAtKey);
    if (ownInviteCode == normalizedInviteCode && ownInviteOwner == currentUser.id) {
      final isExpired = ownInviteExpiresAt != null &&
          DateTime.fromMillisecondsSinceEpoch(ownInviteExpiresAt).isBefore(
            DateTime.now(),
          );
      if (isExpired) {
        throw const PairingFailure('That code is no longer available.');
      }
      throw const PairingFailure(
        'That is your code. Share it with your partner instead.',
      );
    }

    final pair = PairRecord(
      id: 'pair-${normalizedInviteCode.toLowerCase()}',
      memberIds: [currentUser.id, 'user-2'],
      status: 'active',
      inviteCode: normalizedInviteCode,
      partnerDisplayName: 'Sarah',
      expiresInMinutes: 5,
    );
    await _preferences.setString(_pairKey, jsonEncode(pair.toJson()));
    await _clearPendingInvite();
    return pair;
  }

  @override
  Future<void> skipPairing() async {
    await _preferences.remove(_pairKey);
    await _clearPendingInvite();
  }

  Future<void> _clearPendingInvite() async {
    await _preferences.remove(_inviteCodeKey);
    await _preferences.remove(_inviteOwnerKey);
    await _preferences.remove(_inviteExpiresAtKey);
  }
}
