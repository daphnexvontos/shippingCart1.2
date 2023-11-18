import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipping_cart/pages/shipments_page.dart';

import '/pages/cart_page.dart';
import '/pages/contact_page.dart';
import '/pages/landing_page.dart';
import '/pages/new_orders_page.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Image.asset(
          'assets/images/sc_logo_red_whitebg.png',
          width: 48,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CartPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          Obx(() => NavigationBar(
                height: 70,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                selectedIndex: controller.selectedIndex.value,
                // on selected bottom nav bar
                onDestinationSelected: (index) =>
                    controller.selectedIndex.value = index,
                destinations: [
                  // icons at the bottom
                  NavigationDestination(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: ''),
                  NavigationDestination(
                      icon: Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: ''),
                  NavigationDestination(
                      icon: Positioned(
                        top: -5,
                        child: Container(
                          height: 24,
                          width: 24,
                        ),
                      ),
                      label: ''),
                  NavigationDestination(
                      icon: Icon(
                        Icons.list_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: ''),
                  NavigationDestination(
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 30,
                      ),
                      label: ''),
                ],
              )),
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text(
                      'Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Shipments',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11))),
                Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Cart',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11))),
                Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('New Shipment',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11))),
                Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('Contact Us',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11))),
              ],
            ),
          )
        ],
      ),
      body: Obx(() {
        return Stack(children: [
          controller.screens[controller.selectedIndex.value],
        ]);
      }),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const LandingPage(),
    const ShipmentsPage(),
    const CartPage(),
    const NewOrderPage(),
    const ContactPage()
  ];
}