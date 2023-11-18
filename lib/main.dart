import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shipping_cart/api/firebase_api.dart';
// import 'package:shipping_cart/pages/cart_page.dart';
// import 'package:shipping_cart/pages/new_orders_page.dart';
import 'package:shipping_cart/pages/notification_screen.dart';

import 'firebase_options.dart';
import 'pages/auth_page.dart';
import 'pages/login_page.dart';
// import '/pages/address_book_page.dart';
// import '/pages/auth_page.dart';
import '/widgets/navigation_menu.dart';
// import '/pages/profile_page.dart';
// import '/pages/shipments_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final snackbarKey = GlobalKey<ScaffoldMessengerState>();

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print('some notification received');
  }
}

void main() async {
  // await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(LoginUiApp());

  // // Check if logged in
  // if (FirebaseAuth.instance.currentUser == null) {
  //   // User is not signed in
  //   print('User is not signed in');
  // } else {
  //   // User is signed in
  //   print('User is signed in');
  //   // on background notification tapped
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       print('Background Notification Tapped');
  //       navigatorKey.currentState!
  //           .pushNamed('/notification_screen', arguments: message);
  //     }
  //   });
  //   FirebaseApi().getAccount();
  //   // listen to background notifications
  //   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  //   // to handle foreground notifications
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     String payloadData = jsonEncode(message.data);
  //     print('Got a message in foreground');
  //     if (message.notification != null) {
  //       FirebaseApi.showSimpleNotification(
  //           title: message.notification!.title!,
  //           body: message.notification!.body!,
  //           payload: payloadData);
  //     }
  //   });
  // } 

//   // Listen for auth state changes
//   FirebaseAuth.instance.authStateChanges().listen((User? user) {
//   if (user == null) {
//     // User is signed out
//     print('User is signed out');
//   } else {
//     // User is signed in
//     print('User is signed in');
//     // on background notification tapped
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         print('Background Notification Tapped');
//         navigatorKey.currentState!
//             .pushNamed('/notification_screen', arguments: message);
//       }
//     });
//     FirebaseApi().getAccount();
//     // listen to background notifications
//     FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

//     // to handle foreground notifications
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       String payloadData = jsonEncode(message.data);
//       print('Got a message in foreground');
//       if (message.notification != null) {
//         FirebaseApi.showSimpleNotification(
//             title: message.notification!.title!,
//             body: message.notification!.body!,
//             payload: payloadData);
//       }
//     });
//   }
// });
}

class LoginUiApp extends StatefulWidget {
  LoginUiApp({super.key});

  @override
  State<LoginUiApp> createState() => _LoginUiAppState();
}

class _LoginUiAppState extends State<LoginUiApp> {
  final Color _primaryColor = HexColor('#aa0e0e');
  final Color _accentColor = HexColor('#eb1f27');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: snackbarKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login UI',
        theme: ThemeData(
          // navigationBarTheme: Text(),
          primaryColor: _primaryColor,
          hintColor: _accentColor,
          scaffoldBackgroundColor: Colors.grey.shade100,
          primarySwatch: Colors.grey,
        ),
        routes: {
          '/': (context) => const AuthPage(),
          "/notification_screen": (context) => const NotificationPage()
        });
  }

  // final GoRouter _router = GoRouter(
  //   routes: [
  //     GoRoute(
  //       path: '/',
  //       name: 'home',
  //       builder: (context, state) => const AuthPage(),
  //     ),
  //     GoRoute(
  //       path: '/shipments',
  //       name: 'shipments',
  //       builder: (context, state) => const ShipmentsPage(),
  //     ),
  //     GoRoute(
  //       path: '/cart',
  //       name: 'cart',
  //       builder: (context, state) => const CartPage(),
  //     ),
  //     GoRoute(
  //       path: '/newOrder',
  //       name: 'newOrder',
  //       builder: (context, state) => const NewOrderPage(),
  //     ),
  //     GoRoute(
  //       path: '/profile',
  //       name: 'profile',
  //       builder: (context, state) => const ProfilePage(),
  //     ),
  //     GoRoute(
  //       path: '/addressBook',
  //       name: 'addressBook',
  //       builder: (context, state) => const AddressBookPage(),
  //     ),
  //     GoRoute(
  //       path: '/notification_screen',
  //       name: 'notificationScreen',
  //       builder: (context, state) => const NotificationPage(),
  //     ),
  //   ],
  // );
}
