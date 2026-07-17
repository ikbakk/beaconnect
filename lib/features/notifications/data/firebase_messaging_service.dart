import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../domain/notification_payload.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseMessagingService {
  FirebaseMessagingService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final StreamController<NotificationPayload> _foregroundController =
      StreamController<NotificationPayload>.broadcast();
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<String>? _tokenSubscription;

  Stream<NotificationPayload> get foregroundMessages =>
      _foregroundController.stream;

  Future<void> initialize({required String userId}) async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    await _saveToken(userId, await _messaging.getToken());
    await _foregroundSubscription?.cancel();
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      _foregroundController.add(_payloadFrom(message));
    });
    await _tokenSubscription?.cancel();
    _tokenSubscription = _messaging.onTokenRefresh.listen(
      (token) => _saveToken(userId, token),
    );
  }

  Future<NotificationPayload?> getInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    return message == null ? null : _payloadFrom(message);
  }

  Stream<NotificationPayload> get openedMessages =>
      FirebaseMessaging.onMessageOpenedApp.map(_payloadFrom);

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _tokenSubscription?.cancel();
    await _foregroundController.close();
  }

  NotificationPayload _payloadFrom(RemoteMessage message) {
    return NotificationPayload.fromRemoteMessage(
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
    );
  }

  Future<void> _saveToken(String userId, String? token) async {
    if (token == null || token.isEmpty) return;
    await _firestore.collection('users').doc(userId).set({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
