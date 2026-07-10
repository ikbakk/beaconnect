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
    final currentUserId = this.currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      return null;
    }

    final userSnapshot = await _firestore.collection('users').doc(currentUserId).get();
    final userData = userSnapshot.data();
    final activePairId = userData?['activePairId'] as String?;
    if (activePairId == null || activePairId.isEmpty) {
      return null;
    }

    final pairSnapshot = await _firestore.collection('pairs').doc(activePairId).get();
    final pairData = pairSnapshot.data();
    if (pairData == null) {
      return null;
    }

    final memberIds = List<String>.from(pairData['memberIds'] as List<dynamic>? ?? []);
    final partnerDisplayName = await _loadPartnerDisplayName(
      memberIds: memberIds,
      currentUserId: currentUserId,
    );

    return PairRecord(
      id: pairSnapshot.id,
      memberIds: memberIds,
      status: pairData['status'] as String? ?? 'active',
      inviteCode: pairData['inviteCode'] as String? ?? '—',
      partnerDisplayName: partnerDisplayName,
      expiresInMinutes: 5,
    );
  }

  @override
  Future<PairRecord> createInviteCode({required AppUser currentUser}) async {
    final existingInvite = await _findPendingInvite(createdBy: currentUser.id);
    if (existingInvite != null) {
      final existingData = existingInvite.data();
      final expiresAt = existingData?['expiresAt'] as Timestamp?;
      if (!_isExpired(expiresAt)) {
        return PairRecord(
          id: existingData?['pairId'] as String? ?? 'pair-draft-${currentUser.id}',
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
    final expiresAt = Timestamp.fromDate(
      DateTime.now().add(const Duration(minutes: 5)),
    );
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
    final normalizedInviteCode = _normalizeInviteCode(inviteCode);
    if (normalizedInviteCode.isEmpty) {
      throw const PairingFailure(
        'Enter your partner\'s code, or pair later for now.',
      );
    }

    final approval = await _firestore.runTransaction<_ApprovalResult>((
      transaction,
    ) async {
      final inviteRef = _firestore.collection('inviteCodes').doc(normalizedInviteCode);
      final inviteSnapshot = await transaction.get(inviteRef);
      final inviteData = inviteSnapshot.data();
      if (!inviteSnapshot.exists || inviteData == null) {
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
        transaction.set(inviteRef, {'status': 'expired'}, SetOptions(merge: true));
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
      final pairSnapshot = await transaction.get(pairRef);
      final pairData = pairSnapshot.data();
      if (!pairSnapshot.exists || pairData == null) {
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

      transaction.set(pairRef, {
        'memberIds': [createdBy, currentUser.id],
        'status': 'active',
        'inviteCode': normalizedInviteCode,
        'approvedAt': FieldValue.serverTimestamp(),
        'endedAt': null,
      }, SetOptions(merge: true));

      transaction.set(inviteRef, {
        'status': 'approved',
        'usedBy': currentUser.id,
        'usedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      transaction.set(_firestore.collection('users').doc(createdBy), {
        'activePairId': pairId,
      }, SetOptions(merge: true));

      transaction.set(_firestore.collection('users').doc(currentUser.id), {
        'displayName': currentUser.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'activePairId': pairId,
      }, SetOptions(merge: true));

      return _ApprovalResult(pairId: pairId, createdBy: createdBy);
    });

    final partnerDisplayName = await _loadUserDisplayName(approval.createdBy);

    return PairRecord(
      id: approval.pairId,
      memberIds: [approval.createdBy, currentUser.id],
      status: 'active',
      inviteCode: normalizedInviteCode,
      partnerDisplayName: partnerDisplayName,
      expiresInMinutes: 5,
    );
  }

  @override
  Future<void> skipPairing() async {}

  Future<String> _loadPartnerDisplayName({
    required List<String> memberIds,
    required String currentUserId,
  }) async {
    final partnerId = memberIds.where((id) => id != currentUserId).firstOrNull;
    if (partnerId == null) {
      return 'Your partner';
    }

    return _loadUserDisplayName(partnerId);
  }

  Future<String> _loadUserDisplayName(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).get();
    final data = snapshot.data();
    return data?['displayName'] as String? ?? 'Your partner';
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findPendingInvite({
    required String createdBy,
  }) async {
    final snapshot = await _firestore
        .collection('inviteCodes')
        .where('createdBy', isEqualTo: createdBy)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return snapshot.docs.first;
  }

  bool _isExpired(Timestamp? expiresAt) {
    return expiresAt != null && expiresAt.toDate().isBefore(DateTime.now());
  }

  int _expiresInMinutes(Timestamp? expiresAt) {
    if (expiresAt == null) {
      return 5;
    }

    final remaining = expiresAt.toDate().difference(DateTime.now()).inSeconds;
    if (remaining <= 0) {
      return 0;
    }

    return (remaining / 60).ceil();
  }

  String _normalizeInviteCode(String? inviteCode) {
    return inviteCode?.trim().toUpperCase() ?? '';
  }

  String _generateInviteCode() {
    final millis = DateTime.now().millisecondsSinceEpoch.toString();
    return millis.substring(millis.length - 6);
  }
}

class _ApprovalResult {
  const _ApprovalResult({required this.pairId, required this.createdBy});

  final String pairId;
  final String createdBy;
}
