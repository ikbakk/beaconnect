import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/check_in_repository.dart';

class FirebaseCheckInRepository implements CheckInRepository {
  FirebaseCheckInRepository({
    FirebaseFirestore? firestore,
    this.currentUserId,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String? currentUserId;

  DocumentReference<Map<String, dynamic>> get _userDocument {
    final currentUserId = this.currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      throw StateError('A user is required before check-ins can load.');
    }

    return _firestore.collection('users').doc(currentUserId);
  }

  @override
  Future<DateTime?> getLastCheckInAt() async {
    final snapshot = await _userDocument.get();
    final timestamp = snapshot.data()?['lastCheckInAt'] as Timestamp?;
    return timestamp?.toDate();
  }

  @override
  Future<void> saveLastCheckInAt(DateTime timestamp) async {
    await _userDocument.set({
      'lastCheckInAt': Timestamp.fromDate(timestamp),
    }, SetOptions(merge: true));
  }
}
