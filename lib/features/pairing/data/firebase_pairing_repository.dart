import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
import '../domain/pairing_failure.dart';
import '../domain/pairing_repository.dart';

class FirebasePairingRepository implements PairingRepository {
  FirebasePairingRepository({
    FirebaseFirestore? firestore,
    this.currentUserId,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String? currentUserId;

  @override
  Future<PairRecord?> getCurrentPair() async {
    final uid = currentUserId;
    if (uid == null || uid.isEmpty) return null;

    final userSnapshot = await _firestore.collection('users').doc(uid).get();
    final activePairId = userSnapshot.data()?['activePairId'] as String?;
    if (activePairId == null || activePairId.isEmpty) return null;

    final pairSnapshot = await _firestore.collection('pairs').doc(activePairId).get();
    final pairData = pairSnapshot.data();
    if (pairData == null) return null;

    final memberIds = List<String>.from(pairData['memberIds'] as List<dynamic>? ?? []);
    final partnerName = await _loadPartnerName(memberIds);

    return PairRecord(
      id: pairSnapshot.id,
      memberIds: memberIds,
      status: pairData['status'] as String? ?? 'active',
      inviteCode: pairData['inviteCode'] as String? ?? '—',
      partnerDisplayName: partnerName,
      expiresInMinutes: 5,
    );
  }

  @override
  Future<PairRecord> createInviteCode({required AppUser currentUser}) async {
    final existingInvite = await _findPendingInvite(createdBy: currentUser.id);
    if (existingInvite != null) {
      final expiresAt = existingInvite.data()?['expiresAt'] as Timestamp?;
      if (!_isExpired(expiresAt)) {
        final pairId = existingInvite.data()?['pairId'] as String?;
        return PairRecord(
          id: pairId ?? 'pair-draft-${currentUser.id}',
          memberIds: [currentUser.id],
          status: 'pending',
          inviteCode: existingInvite.id,
          partnerDisplayName: 'Your partner',
          expiresInMinutes: _expiresInMinutes(expiresAt),
        );
      }
      await _firestore.collection('inviteCodes').doc(existingInvite.id).set({
        'status': 'expired',
      }, SetOptions(merge: true));
    }

    final code = _generateInviteCode();
    final expiresAt = Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 5)));
    final pairDraftRef = _firestore.collection('pairs').doc();

    await _firestore.runTransaction((transaction) async {
      transaction.set(_firestore.collection('inviteCodes').doc(code), {
        'createdBy': currentUser.id,
        'pairId': pairDraftRef.id,
        'status': 'pending',
        'expiresAt': expiresAt,
        'usedBy': null,
        'usedAt': null,
      });

      transaction.set(pairDraftRef, {
        'memberIds': [currentUser.id],
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'approvedAt': null,
        'endedAt': null,
        'inviteCode': code,
      });

      transaction.set(_firestore.collection('users').doc(currentUser.id), {
        'displayName': currentUser.displayName,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

    return PairRecord(
      id: pairDraftRef.id,
      memberIds: [currentUser.id],
      status: 'pending',
      inviteCode: code,
      partnerDisplayName: 'Your partner',
      expiresInMinutes: _expiresInMinutes(expiresAt),
    );
  }

  @override
  Future<PairRecord> approvePairing({
    required AppUser currentUser,
    String? inviteCode,
  }) async {
    final normalizedCode = _normalizeInviteCode(inviteCode);
    if (normalizedCode.isEmpty) {
      throw const PairingFailure(
        'Enter your partner\'s code, or pair later for now.',
      );
    }

    final result = await _firestore.runTransaction<_ApproveResult>((tx) async {
      final inviteRef = _firestore.collection('inviteCodes').doc(normalizedCode);
      final inviteSnap = await tx.get(inviteRef);
      final inviteData = inviteSnap.data();
      if (!inviteSnap.exists || inviteData == null) {
        throw const PairingFailure(
          'That code is not available right now. Check it and try again.',
        );
      }

      final status = inviteData['status'] as String? ?? 'pending';
      if (status != 'pending') {
        throw const PairingFailure('That code is no longer available.');
      }

      final expiresAt = inviteData['expiresAt'] as Timestamp?;
      if (_isExpired(expiresAt)) {
        tx.set(inviteRef, {'status': 'expired'}, SetOptions(merge: true));
        throw const PairingFailure('That code is no longer available.');
      }

      final createdBy = inviteData['createdBy'] as String?;
      if (createdBy == null || createdBy.isEmpty) {
        throw const PairingFailure(
          'Something did not go as expected. Please try again in a moment.',
        );
      }
      if (createdBy == currentUser.id) {
        throw const PairingFailure(
          'That is your code. Share it with your partner instead.',
        );
      }

      final pairId = inviteData['pairId'] as String?;
      if (pairId == null || pairId.isEmpty) {
        throw const PairingFailure(
          'Something did not go as expected. Please try again in a moment.',
        );
      }

      final pairRef = _firestore.collection('pairs').doc(pairId);
      final pairSnap = await tx.get(pairRef);
      final pairData = pairSnap.data();
      if (!pairSnap.exists || pairData == null) {
        throw const PairingFailure(
          'Something did not go as expected. Please try again in a moment.',
        );
      }

      final memberIds = List<String>.from(pairData['memberIds'] as List<dynamic>? ?? []);
      if (memberIds.contains(currentUser.id)) {
        throw const PairingFailure('You are already connected with this code.');
      }
      if (memberIds.length > 1) {
        throw const PairingFailure('That code has already been used.');
      }

      tx.set(pairRef, {
        'memberIds': [createdBy, currentUser.id],
        'status': 'pending',
        'inviteCode': normalizedCode,
        'approvedAt': FieldValue.serverTimestamp(),
        'endedAt': null,
      }, SetOptions(merge: true));

      tx.set(inviteRef, {
        'status': 'approved',
        'usedBy': currentUser.id,
        'usedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      tx.set(_firestore.collection('users').doc(createdBy), {
        'activePairId': pairId,
      }, SetOptions(merge: true));

      tx.set(_firestore.collection('users').doc(currentUser.id), {
        'displayName': currentUser.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'activePairId': pairId,
      }, SetOptions(merge: true));

      return _ApproveResult(pairId: pairId, createdBy: createdBy);
    });

    final pair = await _loadPairById(result.pairId);
    return pair;
  }

  @override
  Future<PairRecord> confirmPairing({required AppUser currentUser}) async {
    final pair = await getCurrentPair();
    if (pair == null) {
      throw const PairingFailure(
        'There is nothing to confirm. Try pairing again.',
      );
    }
    if (pair.status == 'active') {
      return pair;
    }
    if (pair.status != 'pending') {
      throw const PairingFailure(
        'Connection could not be confirmed. Try pairing again.',
      );
    }
    if (!pair.memberIds.contains(currentUser.id)) {
      throw const PairingFailure('You are not part of this connection.');
    }

    final pairRef = _firestore.collection('pairs').doc(pair.id);
    await pairRef.set({'status': 'active'}, SetOptions(merge: true));

    return PairRecord(
      id: pair.id,
      memberIds: pair.memberIds,
      status: 'active',
      inviteCode: pair.inviteCode,
      partnerDisplayName: pair.partnerDisplayName,
      expiresInMinutes: pair.expiresInMinutes,
    );
  }

  @override
  Future<void> skipPairing() async {}

  Future<PairRecord> _loadPairById(String pairId) async {
    final pairSnap = await _firestore.collection('pairs').doc(pairId).get();
    final pairData = pairSnap.data();
    if (pairData == null) {
      throw const PairingFailure('Connection is not ready. Try again.');
    }
    final memberIds = List<String>.from(pairData['memberIds'] as List<dynamic>? ?? []);
    final partnerName = await _loadPartnerName(memberIds);
    return PairRecord(
      id: pairSnap.id,
      memberIds: memberIds,
      status: pairData['status'] as String? ?? 'pending',
      inviteCode: pairData['inviteCode'] as String? ?? '—',
      partnerDisplayName: partnerName,
      expiresInMinutes: 5,
    );
  }

  Future<String> _loadPartnerName(List<String> memberIds) async {
    final partnerId = memberIds.where((id) => id != currentUserId).firstOrNull;
    if (partnerId == null) return 'Your partner';
    final snap = await _firestore.collection('users').doc(partnerId).get();
    return snap.data()?['displayName'] as String? ?? 'Your partner';
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findPendingInvite({required String createdBy}) async {
    final snap = await _firestore
        .collection('inviteCodes')
        .where('createdBy', isEqualTo: createdBy)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first;
  }

  bool _isExpired(Timestamp? ts) =>
      ts != null && ts.toDate().isBefore(DateTime.now());

  int _expiresInMinutes(Timestamp? ts) {
    if (ts == null) return 5;
    final remaining = ts.toDate().difference(DateTime.now()).inSeconds;
    if (remaining <= 0) return 0;
    return (remaining / 60).ceil();
  }

  String _normalizeInviteCode(String? code) => code?.trim().toUpperCase() ?? '';

  String _generateInviteCode() {
    final millis = DateTime.now().millisecondsSinceEpoch.toString();
    return millis.substring(millis.length - 6);
  }
}

class _ApproveResult {
  const _ApproveResult({required this.pairId, required this.createdBy});
  final String pairId;
  final String createdBy;
}
