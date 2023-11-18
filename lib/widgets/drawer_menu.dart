import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_cart/pages/address_book_page.dart';
import 'package:shipping_cart/pages/landing_page.dart';
import 'package:shipping_cart/pages/profile_page.dart';
// import 'package:go_router/go_router.dart';

import '../pages/login_page.dart';
import '../pages/auth_page.dart';
import '/widgets/navigation_menu.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  final double _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Shipping Cart AU",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.home,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavigationMenu()))),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
                leading: Icon(
                  Icons.account_circle,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Profile Page',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).hintColor),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()))),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.menu_book,
                size: _drawerIconSize,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Address Book',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddressBookPage()));
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
