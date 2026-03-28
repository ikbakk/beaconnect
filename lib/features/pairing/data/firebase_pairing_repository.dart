import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/app_user.dart';
import '../domain/pair_record.dart';
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
      });

      transaction.set(pairDraftRef, {
        'memberIds': [currentUser.id],
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
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
      expiresInMinutes: 5,
    );
  }

  @override
  Future<PairRecord> approvePairing({
    required AppUser currentUser,
    String? inviteCode,
  }) async {
    final trimmedInviteCode = inviteCode?.trim();
    final pendingInvite = trimmedInviteCode == null || trimmedInviteCode.isEmpty
        ? await _findPendingInvite(createdBy: currentUser.id)
        : await _loadPendingInviteByCode(trimmedInviteCode);
    if (pendingInvite == null) {
      throw StateError('Something did not go as expected.');
    }

    final resolvedInviteCode = pendingInvite.id;
    final inviteData = pendingInvite.data();
    if (inviteData == null) {
      throw StateError('Something did not go as expected.');
    }
    final expiresAt = inviteData['expiresAt'] as Timestamp?;
    if (expiresAt != null && expiresAt.toDate().isBefore(DateTime.now())) {
      throw StateError('This code is no longer available.');
    }

    final pairId = inviteData['pairId'] as String?;
    if (pairId == null || pairId.isEmpty) {
      throw StateError('Something did not go as expected.');
    }
    final createdBy = inviteData['createdBy'] as String?;
    if (createdBy == null || createdBy.isEmpty) {
      throw StateError('Something did not go as expected.');
    }

    final pairRef = _firestore.collection('pairs').doc(pairId);
    final createdByUserRef = _firestore.collection('users').doc(createdBy);
    final currentUserRef = _firestore.collection('users').doc(currentUser.id);

    await _firestore.runTransaction((transaction) async {
      transaction.set(pairRef, {
        'memberIds': [createdBy, currentUser.id],
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'endedAt': null,
        'inviteCode': resolvedInviteCode,
      }, SetOptions(merge: true));

      transaction.set(_firestore.collection('inviteCodes').doc(resolvedInviteCode), {
        'status': 'approved',
        'usedBy': currentUser.id,
      }, SetOptions(merge: true));

      transaction.set(createdByUserRef, {
        'activePairId': pairId,
      }, SetOptions(merge: true));

      transaction.set(currentUserRef, {
        'displayName': currentUser.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'activePairId': pairId,
      }, SetOptions(merge: true));
    });

    final partnerDisplayName = await _loadUserDisplayName(createdBy);

    return PairRecord(
      id: pairId,
      memberIds: [createdBy, currentUser.id],
      status: 'active',
      inviteCode: resolvedInviteCode,
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

  Future<DocumentSnapshot<Map<String, dynamic>>?> _loadPendingInviteByCode(
    String inviteCode,
  ) async {
    final snapshot = await _firestore.collection('inviteCodes').doc(inviteCode).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    if ((data['status'] as String?) != 'pending') {
      return null;
    }

    return snapshot;
  }

  String _generateInviteCode() {
    final millis = DateTime.now().millisecondsSinceEpoch.toString();
    return millis.substring(millis.length - 6);
  }
}
