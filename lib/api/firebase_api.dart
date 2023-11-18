import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shipping_cart/main.dart';

int notificationId = 0;

// OG
class FirebaseApi {
  // create instance of Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> init() async {
    _firebaseMessaging.subscribeToTopic('channelIdUpdate');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleFCMMessage(message);
    });
  }

  void handleFCMMessage(RemoteMessage message) {
    if (message.data != null && message.data['channelId'] != null) {
      String channelId = message.data['channelId'];
      String tm = message.data['trackingNumber'];
      String payloadData = jsonEncode(message.data);
      print('Received ChannelId update: $channelId');
      showSimpleNotification(
          title: message.notification?.title ?? 'Notification Title',
          body: message.notification?.body ?? 'Notification Body',
          payload: payloadData,
          channelID: channelId,
          trackingNumber: tm);
      // Handle the channelId update or notification as needed
    }
  }

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final db = FirebaseFirestore.instance;
  var accountNo;
  final email = FirebaseAuth.instance.currentUser!.email;

  // Get user accountNo
  Future<void> getAccount() async {
    final allUsers = FirebaseFirestore.instance.collection("users");
    allUsers.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["email"] == email) {
            accountNo = docSnapshot.data()['accountNo'];
            initNotifications();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  // function to initialize notifs
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token
    print('Token: $fCMToken');

    db.collection('users').doc(accountNo).update({"fCMToken": fCMToken});
    localNotiInit();
  }

  // Initialize local notifications
  Future localNotiInit() async {
    // Initialize plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed('/notification_screen', arguments: notificationResponse);
  }

  // show a simple notification
  static Future showSimpleNotification(
      {required String title,
      required String body,
      required String payload,
      required String channelID,
      required String trackingNumber}) async {
    notificationId++;
    String uniqueId = '$channelID-$trackingNumber';
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(uniqueId, 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            icon: '@drawable/sc_logo_red');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        notificationId, title, body, notificationDetails,
        payload: payload);
  }
}


// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shipping_cart/main.dart';

// class FirebaseApi {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final db = FirebaseFirestore.instance;

//   int notificationId = 0;
//   var accountNo;
//   final email = FirebaseAuth.instance.currentUser!.email;

//   // List to store pending notifications
//   List<Map<String, dynamic>> pendingNotifications = [];

//   Future<void> init() async {
//     _firebaseMessaging.subscribeToTopic('channelIdUpdate');

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       handleFCMMessage(message);
//     });
//   }

//   void handleFCMMessage(RemoteMessage message) {
//     if (message.data != null && message.data['channelId'] != null) {
//       String channelId = message.data['channelId'];
//       String tm = message.data['trackingNumber'];
//       String payloadData = jsonEncode(message.data);
//       print('Received ChannelId update: $channelId');

//       if (FirebaseAuth.instance.currentUser != null) {
//         // User is logged in, show the notification
//         showSimpleNotification(
//           title: message.notification?.title ?? 'Notification Title',
//           body: message.notification?.body ?? 'Notification Body',
//           payload: payloadData,
//           channelID: channelId,
//           trackingNumber: tm,
//         );
//       } else {
//         // User is not logged in, add notification to pending list
//         pendingNotifications.add({
//           'title': message.notification?.title ?? 'Notification Title',
//           'body': message.notification?.body ?? 'Notification Body',
//           'payload': payloadData,
//           'channelID': channelId,
//           'trackingNumber': tm,
//         });
//       }
//     }
//   }

//   Future<void> getAccount() async {
//     final allUsers = FirebaseFirestore.instance.collection("users");
//     allUsers.get().then(
//       (querySnapshot) {
//         for (var docSnapshot in querySnapshot.docs) {
//           if (docSnapshot.data()["email"] == email) {
//             accountNo = docSnapshot.data()['accountNo'];
//             _firebaseMessaging.requestPermission(
//               alert: true,
//               announcement: true,
//               badge: true,
//               carPlay: false,
//               criticalAlert: false,
//               provisional: false,
//               sound: true,
//             );
//             _firebaseMessaging.getToken().then((fCMToken) {
//               print('Token: $fCMToken');
//               db.collection('users').doc(accountNo).update({"fCMToken": fCMToken});
//               localNotiInit();
//               // Show pending notifications if user is now logged in
//               showPendingNotifications();
//             });
//           }
//         }
//       },
//       onError: (e) => print("Error getting document: $e"),
//     );
//   }

//   Future<void> localNotiInit() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       onDidReceiveLocalNotification: (id, title, body, payload) => null,
//     );
//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsDarwin,
//             linux: initializationSettingsLinux);
//     _flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: onNotificationTap,
//         onDidReceiveBackgroundNotificationResponse: onNotificationTap);
//   }

//   static void onNotificationTap(NotificationResponse notificationResponse) {
//     navigatorKey.currentState!
//         .pushNamed('/notification_screen', arguments: notificationResponse);
//   }

//   Future<void> showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//     required String channelID,
//     required String trackingNumber
//   }) async {
//     notificationId++;
//     String uniqueId='$channelID-$trackingNumber';
//      AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//           uniqueId, 'channel name',
//             channelDescription: 'channel description',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker',
//             icon:'@drawable/sc_logo_red');
//      NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await _flutterLocalNotificationsPlugin
//         .show(notificationId, title, body, notificationDetails, payload: payload);
//   }

//   // Show pending notifications when the user logs in
//   void showPendingNotifications() {
//     for (var notification in pendingNotifications) {
//       showSimpleNotification(
//         title: notification['title'],
//         body: notification['body'],
//         payload: notification['payload'],
//         channelID: notification['channelID'],
//         trackingNumber: notification['trackingNumber'],
//       );
//     }
//     // Clear the list after showing pending notifications
//     pendingNotifications.clear();
//   }
// }

