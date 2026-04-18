import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/check_in_repository.dart';

class FirebaseCheckInRepository implements CheckInRepository {
  FirebaseCheckInRepository({FirebaseFirestore? firestore, this._pairId})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String? _pairId;

  CollectionReference<Map<String, dynamic>> get _eventsCollection {
    final pairId = _pairId;
    if (pairId == null || pairId.isEmpty) {
      throw StateError('A pair is required before check-ins can load.');
    }

    return _firestore.collection('pairs').doc(pairId).collection('events');
  }

  @override
  Future<DateTime?> getLastCheckInAt() async {
    final snapshot = await _eventsCollection
        .where('type', isEqualTo: 'Checked in')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final timestamp = snapshot.docs.first.data()['createdAt'] as Timestamp?;
    return timestamp?.toDate();
  }

  @override
  Future<void> saveLastCheckInAt(DateTime timestamp) async {
    await _eventsCollection.add({
      'type': 'Checked in',
      'actorUserId': 'current-user',
      'createdAt': Timestamp.fromDate(timestamp),
      'placeLabel': 'Current place',
      'detail': 'Check-in sent.',
    });
  }
}
