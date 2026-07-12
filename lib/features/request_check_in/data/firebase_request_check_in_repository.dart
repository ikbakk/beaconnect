import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/request_check_in_repository.dart';

class FirebaseRequestCheckInRepository implements RequestCheckInRepository {
  FirebaseRequestCheckInRepository({
    FirebaseFirestore? firestore,
    this.pairId,
    this.currentUserId,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String? pairId;
  final String? currentUserId;

  DocumentReference<Map<String, dynamic>> get _userDocument {
    final currentUserId = this.currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      throw StateError('A user is required before requests can load.');
    }

    return _firestore.collection('users').doc(currentUserId);
  }

  CollectionReference<Map<String, dynamic>> get _requestsCollection {
    final pairId = this.pairId;
    if (pairId == null || pairId.isEmpty) {
      throw StateError('A pair is required before requests can load.');
    }

    return _firestore.collection('pairs').doc(pairId).collection('checkInRequests');
  }

  @override
  Future<void> createRequest({
    required DateTime createdAt,
    required String requesterUserId,
    required String requesterName,
    required String partnerUserId,
  }) async {
    final requestRef = _requestsCollection.doc();
    final batch = _firestore.batch();

    batch.set(_userDocument, {
      'lastRequestCheckInAt': Timestamp.fromDate(createdAt),
    }, SetOptions(merge: true));

    batch.set(requestRef, {
      'actorUserId': requesterUserId,
      'actorDisplayName': requesterName,
      'targetUserId': partnerUserId,
      'status': 'pending',
      'response': null,
      'createdAt': FieldValue.serverTimestamp(),
      'respondedAt': null,
    });

    await batch.commit();
  }

  @override
  Future<DateTime?> getLastRequestAt() async {
    final snapshot = await _userDocument.get();
    final timestamp = snapshot.data()?['lastRequestCheckInAt'] as Timestamp?;
    return timestamp?.toDate();
  }

  @override
  Future<bool> respondToLatestIncomingRequest({
    required String responderUserId,
    required String response,
  }) async {
    final snapshot = await _requestsCollection
        .where('targetUserId', isEqualTo: responderUserId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      return false;
    }

    await snapshot.docs.first.reference.set({
      'status': 'responded',
      'response': response,
      'respondedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return true;
  }
}
