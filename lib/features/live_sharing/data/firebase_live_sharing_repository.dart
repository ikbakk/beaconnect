import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/live_sharing_repository.dart';
import '../domain/live_sharing_session.dart';

class FirebaseLiveSharingRepository implements LiveSharingRepository {
  FirebaseLiveSharingRepository({
    FirebaseFirestore? firestore,
    this.pairId,
    this.currentUserId,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String? pairId;
  final String? currentUserId;

  CollectionReference<Map<String, dynamic>> get _sessionsCollection {
    final pairId = this.pairId;
    if (pairId == null || pairId.isEmpty) {
      throw StateError('A pair is required before live sharing can load.');
    }

    return _firestore.collection('pairs').doc(pairId).collection('liveSessions');
  }

  String get _actorUserId {
    final currentUserId = this.currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      throw StateError('A user is required before live sharing can load.');
    }

    return currentUserId;
  }

  @override
  Future<void> end() async {
    final doc = await _loadActorSessionDocument();
    if (doc == null) {
      return;
    }

    await doc.reference.set({
      'status': 'ended',
      'endedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<LiveSharingSession?> getCurrentSession() async {
    final snapshot = await _sessionsCollection.get();
    final docs = snapshot.docs.where((doc) {
      final data = doc.data();
      final status = data['status'] as String? ?? 'active';
      final endedAt = data['endedAt'] as Timestamp?;
      return endedAt == null && (status == 'active' || status == 'paused');
    }).toList();

    if (docs.isEmpty) {
      return null;
    }

    docs.sort((a, b) {
      final aTime = (a.data()['startedAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = (b.data()['startedAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    final session = _sessionFromDocument(docs.first);
    if (session == null) {
      return null;
    }

    if (!session.isPaused && session.isExpired) {
      return null;
    }

    return session;
  }

  @override
  Future<LiveSharingSession?> pause() async {
    final doc = await _loadActorSessionDocument();
    final current = doc == null ? null : _sessionFromDocument(doc);
    if (doc == null || current == null || current.isPaused) {
      return current;
    }

    final pausedAt = DateTime.now();
    final remaining = _remainingMinutes(current.endsAt, from: pausedAt);
    await doc.reference.set({
      'status': 'paused',
      'pausedAt': Timestamp.fromDate(pausedAt),
      'remainingMinutes': remaining,
    }, SetOptions(merge: true));

    return current.copyWith(
      isPaused: true,
      pausedAt: pausedAt,
      minutesRemaining: remaining,
    );
  }

  @override
  Future<LiveSharingSession?> resume() async {
    final doc = await _loadActorSessionDocument();
    final current = doc == null ? null : _sessionFromDocument(doc);
    if (doc == null || current == null || !current.isPaused) {
      return current;
    }

    final resumedAt = DateTime.now();
    final endsAt = resumedAt.add(Duration(minutes: current.minutesRemaining));
    await doc.reference.set({
      'status': 'active',
      'pausedAt': null,
      'endedAt': null,
      'expiresAt': Timestamp.fromDate(endsAt),
      'remainingMinutes': current.minutesRemaining,
    }, SetOptions(merge: true));

    return current.copyWith(
      isPaused: false,
      startedAt: current.startedAt,
      endsAt: endsAt,
      clearPausedAt: true,
    );
  }

  @override
  Future<LiveSharingSession> start({required int minutes, String? reason}) async {
    final startedAt = DateTime.now();
    final endsAt = startedAt.add(Duration(minutes: minutes));
    final docRef = _sessionsCollection.doc(_actorUserId);
    await docRef.set({
      'actorUserId': _actorUserId,
      'status': 'active',
      'reason': reason,
      'startedAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(endsAt),
      'pausedAt': null,
      'endedAt': null,
      'remainingMinutes': minutes,
    }, SetOptions(merge: true));

    return LiveSharingSession(
      id: docRef.id,
      minutesRemaining: minutes,
      reason: reason,
      isPaused: false,
      startedAt: startedAt,
      endsAt: endsAt,
      pausedAt: null,
    );
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _loadActorSessionDocument() async {
    final snapshot = await _sessionsCollection.doc(_actorUserId).get();
    if (!snapshot.exists) {
      return null;
    }

    final all = await _sessionsCollection.where('actorUserId', isEqualTo: _actorUserId).limit(1).get();
    if (all.docs.isEmpty) {
      return null;
    }
    return all.docs.first;
  }

  LiveSharingSession? _sessionFromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final status = data['status'] as String? ?? 'active';
    final reason = data['reason'] as String?;
    final remainingMinutes = data['remainingMinutes'] as int?;
    final startedAt = (data['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
    final pausedAt = (data['pausedAt'] as Timestamp?)?.toDate();
    final isPaused = status == 'paused';
    final endsAt = expiresAt ?? startedAt.add(Duration(minutes: remainingMinutes ?? 0));
    final minutesRemaining = isPaused
        ? (remainingMinutes ?? _remainingMinutes(endsAt, from: pausedAt))
        : _remainingMinutes(endsAt);

    return LiveSharingSession(
      id: doc.id,
      minutesRemaining: minutesRemaining,
      reason: reason,
      isPaused: isPaused,
      startedAt: startedAt,
      endsAt: endsAt,
      pausedAt: pausedAt,
    );
  }

  int _remainingMinutes(DateTime endsAt, {DateTime? from}) {
    final remainingSeconds = endsAt.difference(from ?? DateTime.now()).inSeconds;
    if (remainingSeconds <= 0) {
      return 0;
    }

    return (remainingSeconds / 60).ceil();
  }
}
