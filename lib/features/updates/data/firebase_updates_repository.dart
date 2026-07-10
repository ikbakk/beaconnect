import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/update_story.dart';
import '../domain/updates_repository.dart';

class FirebaseUpdatesRepository implements UpdatesRepository {
  FirebaseUpdatesRepository({
    FirebaseFirestore? firestore,
    this.pairId,
    this.currentUserId,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String? pairId;
  final String? currentUserId;

  CollectionReference<Map<String, dynamic>> get _eventsCollection {
    final pairId = this.pairId;
    if (pairId == null || pairId.isEmpty) {
      throw StateError('A pair is required before updates can load.');
    }

    return _firestore.collection('pairs').doc(pairId).collection('events');
  }

  String get _actorUserId {
    final currentUserId = this.currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      throw StateError('A user is required before updates can load.');
    }

    return currentUserId;
  }

  @override
  Future<void> addUpdate(UpdateStory update) async {
    await _eventsCollection.add({
      'type': update.title,
      'actorUserId': _actorUserId,
      'createdAt': FieldValue.serverTimestamp(),
      'placeLabel': update.place,
      'detail': update.story,
    });
  }

  @override
  Future<List<UpdateStory>> getUpdates() async {
    final snapshot = await _eventsCollection.orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UpdateStory(
        timeGroup: 'Recent',
        title: data['type'] as String? ?? 'Update',
        story: data['detail'] as String? ?? 'Something did not go as expected.',
        place: data['placeLabel'] as String? ?? 'Current place',
      );
    }).toList();
  }

  @override
  Future<void> saveUpdates(List<UpdateStory> updates) async {
    for (final update in updates) {
      await addUpdate(update);
    }
  }
}
