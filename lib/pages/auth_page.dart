import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_cart/pages/landing_page.dart';
import 'package:shipping_cart/pages/login_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../api/firebase_api.dart';
import '../widgets/navigation_menu.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print('some notification received');
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            print('authtrue');
            // navigate to landing page

            // on background notification tapped
            FirebaseMessaging.onMessageOpenedApp
                .listen((RemoteMessage message) {
              if (message.notification != null) {
                print('Background Notification Tapped');
                navigatorKey.currentState!
                    .pushNamed('/notification_screen', arguments: message);
              }
            });
            FirebaseApi().getAccount();
            // listen to background notifications
            FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

            // to handle foreground notifications
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              String payloadData = jsonEncode(message.data);
              print('Got a message in foreground');
              if (message.notification != null) {
                FirebaseApi.showSimpleNotification(
                    title: message.notification!.title!,
                    body: message.notification!.body!,
                    payload: payloadData,
                    channelID: message.data['channelId'],
                    trackingNumber: message.data['trackingNumber'],
                    );
              }
            });
            return NavigationMenu();
          }
          // user is NOT logged in
          else {
            // delete user token so notifs are not received
            FirebaseMessaging.instance.deleteToken();
            print('authfalse');
            return LoginPage();
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}