import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../common/theme_helper.dart';
import '../models/warehouse_address.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/header_widget.dart';
import '/pages/notification_screen.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<ContactPage> {
  final double _headerHeight = 250;
  // final currentDate = DateTime.now();
  var numItems = 0;
  final db = FirebaseFirestore.instance;
  var dateCheckout = [];
  var dateStored = [];
  var daysInStorage;
  var trackingNoArr = ['0'];
  var cartArr = ['-'];
  var shipmentsArr = ['-'];
  var shipmentsBundleArr = [];
  var shipmentImage = 'https://www.shippingcart.com/images/sc-icon.png';
  var shipmentsNotesArr = [];
  var shipmentsValueArr = [];
  var shipmentsStatusArr = ['-'];
  var shipmentsDeliveredArr = ['-'];
  var shipmentsDepartedArr = ['-'];
  var shipmentsPackingArr = ['-'];
  var shipmentsPackageArr = ['-'];
  var shipmentsPickingArr = ['-'];
  var shipmentsPutawayArr = ['-'];
  var shipmentsShipArr = ['-'];
  var itemArr = [];
  var sum = 0;
  String phone = '';
  String accountNo = '';
  var accountNoArr = [];
  var selectedBundle;
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final postCodeController = TextEditingController();
  final messageController = TextEditingController();

  List<AddressCardItem> items = [
    AddressCardItem(
      country: "Philippines",
      address:
          "2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto, Niño Parañaque City, 1704 Metro Manila \nPhone: TBA",
      numberItems: '0 ITEMS IN YOUR CART',
      flag: 'assets/images/philippines_pin.png',
    ),
    AddressCardItem(
      country: "United Kingdom",
      address:
          "Unit 9 Ashford Business Complex, 166 Feltham Road, Account No. 73-453736, Ashford, Surrey TW151YQ",
      numberItems: "0 ITEMS IN YOUR CART",
      flag: 'assets/images/united_kingdom_pin.png',
    ),
  ];

  List<String> attachments = [];
  bool isHTML = false;

  final _recipientController = TextEditingController(
    text: 'example@example.com',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );

  Future<void> send() async {
    final Email email = Email(
      body: "emailController.text",
      subject: "Shipping Cart",
      recipients: ["dyatco@gmail.com"],
      attachmentPaths: attachments,
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  final email = FirebaseAuth.instance.currentUser!.email;
  final controller = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: NavigationDrawer(),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              padding: EdgeInsets.only(left: 8.0),
              child: Image.asset('assets/images/sc_logo.png'),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              // Notification Button
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                },
                icon: Icon(Icons.notifications, size: 36),
              ),
              // Drawer Menu
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu, size: 36),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              )
            ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SizedBox(
                    height: _headerHeight,
                    child: HeaderWidget(
                        _headerHeight,
                        false,
                        Icons
                            .login_rounded), //let's create a common header widget
                  ),
                  Container(
                      width: 250,
                      height: _headerHeight,
                      child: PageView(
                        children: [
                          Container(
                              width: 300,
                              child: Center(
                                  child: Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      child: Text("CONTACT US",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  )
                                ],
                              ))),
                        ],
                      )),
                ],
              ),
              // Header
              SizedBox(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Column(children: [
                        SizedBox(height: 12.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: numberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Mobile Number',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: postCodeController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Post Code/Suburb',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Your Message',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            maxLines: 5,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () {
                            send();
                            // send();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Send')],
                          ),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              shape: StadiumBorder()),                                                    
                        ),
                        const SizedBox(height: 38.0),
                      ]))),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard({
    required AddressCardItem item,
  }) =>
      Container(
        width: 260,
        height: 120,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                  spreadRadius: .1,
                  blurRadius: 15,
                  offset: const Offset(-5, 5)),
            ],
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),

        // Country
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                child: Center(
                    child: Text(
                  textAlign: TextAlign.center,
                  item.country,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
              // Address
              Container(
                  width: double.maxFinite,
                  // should be dynamic
                  height: 140,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              '$accountNo ${item.address}',
                              maxFontSize: 15,
                              minFontSize: 12,
                              maxLines: 4,
                            ),
                            Row(children: [
                              Expanded(child: Container()),
                              Container(
                                height: 30,
                                child:
                                    Image.asset(item.flag, fit: BoxFit.cover),
                              ),
                            ]),
                          ]))),
              // Number of items in cart
              Container(
                height: 35,
                child: Center(
                  child: AutoSizeText(
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    item.numberItems,
                    minFontSize: 13,
                    maxLines: 1,
                  ),
                ),
              ),
            ]),
      );
}

// Navigation Drawer
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DrawerMenu();
}