import 'dart:async';
import 'dart:io';

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/usuario_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageStreamController = StreamController<String>.broadcast();

  Stream<String> get mensajes => _messageStreamController.stream;

  initNotification() {
    //eKwx00nQTLqMphgiM2NWFH:APA91bHQ1q_JXjjdbu06MS70y1vFwGLGlcSJI3iqre9W7qypF1sBQudll9lQQKxNHx1h1qNz9rR2qKyuBVVg9agoPXaS57yvRGsw_3svjZMHxovO4_O1PyyRdb71x2hTZB24tiTDHbmU
    //c0uZbiE5QW2lecRxmXKPgO:APA91bHIiMOAQWyWNR01hJLc_jjT-4VyuYyY9Pt-JtMrKQ_fN4pfzXLRxvWkddV9DUrN2npIyef5PNL3lYDY3PZ6ZF8uSltltCwcZzMDW9Ke9-t9k_OQEwg5jLQVU6VZRiYzT2geLUis

    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token) {
      print("=== FCM TOKEN ====");
      print(token);
      final usuarioService = new UsuarioService();
      usuarioService.updateToken(token).then((value) => print(value));
    });

    // ignore: missing_return
    _firebaseMessaging.configure(onMessage: (info) {
      print("====== ONmessage ======");
      print(info);
      String argumento = 'no-data';
      if (Platform.isAndroid) {
        argumento = info['data'] ?? 'no-data';
      }
      _messageStreamController.sink.add(argumento);
      // ignore: missing_return
    }, onLaunch: (info) {
      print("====== onLaunch ======");
      print(info);
      final noti = info['data'];
      print(noti);
      // ignore: missing_return
    }, onResume: (info) {
      print("====== onResume ======");
      print(info);
      final noti = info['data'];
      print(noti);
    });
  }

  dispose() {
    _messageStreamController.close();
  }
}
