import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shipping_cart/pages/shipments_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../models/warehouse_address.dart';
import '/pages/item_page.dart';
import '/pages/notification_screen.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/header_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
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

  final screens = [
    LandingPage(),
    LandingPage(),
    LandingPage(),
    LandingPage(),
    LandingPage(),
  ];

  final email = FirebaseAuth.instance.currentUser!.email;
  final controller = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    _getAccount();
   
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getAccount() async {
    final allUsers = FirebaseFirestore.instance.collection("users");
    allUsers.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["email"] == email) {
            setState(() {
              accountNo = docSnapshot.data()['accountNo'];
              accountNoArr.add(docSnapshot.data()['accountNo']);
            });
            getOrderIds();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(accountNo);
  }

  // Get Cart and Shipments Data
  Future getOrderIds() async {
    sum = 0;
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        //Cart data to get no of items in cart
        // done put away
        if (docSnapshot.data().containsValue('Done Put-away')) {
          setState(() {
            cartArr.add(docSnapshot.id);
          });
        }

        // Shipments only, no cart items
        if (docSnapshot.data()['status'] != 'pending receive' &&
            docSnapshot.data()['status'] != 'Done Receive' &&
            docSnapshot.data()['status'] != 'Pending Put-away' &&
            docSnapshot.data()['status'] != 'For Put-away' &&
            docSnapshot.data()['status'] != 'Done Put-away') {
          // Date Received
          int ts = docSnapshot.data()['dateReceive'].millisecondsSinceEpoch;
          DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
          String dateTime = tsdate.year.toString() +
              "/" +
              tsdate.month.toString() +
              "/" +
              tsdate.day.toString();
          var date = DateFormat('yyyy/MM/dd').parse(dateTime);
          dateStored.add(DateFormat('yyyy, MM, dd').format(date));
          // Date Checkout
          int tsCheckout =
              docSnapshot.data()['dateCheckout'].millisecondsSinceEpoch;
          DateTime tsdateCheckout =
              DateTime.fromMillisecondsSinceEpoch(tsCheckout);
          String dateTimeCheckout = tsdateCheckout.year.toString() +
              "/" +
              tsdateCheckout.month.toString() +
              "/" +
              tsdateCheckout.day.toString();
          var dateOut = DateFormat('yyyy/MM/dd').parse(dateTimeCheckout);
          dateCheckout.add(DateFormat('yyyy, MM, dd').format(dateOut));
          setState(() {
            shipmentsArr.add(docSnapshot.id);
            // Show package no if 'on its way' or 'delivered'
            docSnapshot.data()['status'] == 'For Departed' || 
            docSnapshot.data()['status'] == 'Departed' || 
            docSnapshot.data()['status'] == 'Arrived' || 
            docSnapshot.data()['status'] == 'Warehouse Received' || 
            docSnapshot.data()['status'] == 'For Delivery' || 
            docSnapshot.data()['status'] == 'Done' &&  docSnapshot.data().containsKey('sdeliveredDate')  ? 
            shipmentsPackageArr.add(docSnapshot.data()['packageNumber']) : shipmentsPackageArr.add(''); 
            shipmentsValueArr.add(docSnapshot.data()['invoiceValue']);
            shipmentsNotesArr.add(docSnapshot.data()['notes']);
            shipmentsBundleArr.add(docSnapshot.data()['bundleType']);
            shipmentsStatusArr.add(docSnapshot.data()['status'].toString());
          });
          if (docSnapshot.data().containsKey('isDeparted')) {
            setState(() {
              shipmentsDepartedArr
                  .add(docSnapshot.data()['isDeparted'].toString());
              shipmentsDeliveredArr
                  .add(docSnapshot.data()['isDelivered'].toString());
              shipmentsShipArr.add(docSnapshot.data()['isToShip'].toString());
            });
          }
        } else {
          
        }
      }
    });
    setState(() {
      cartArr.removeAt(0);
      shipmentsArr.removeAt(0);
      shipmentsStatusArr.removeAt(0);
      shipmentsDepartedArr.removeAt(0);
      shipmentsShipArr.removeAt(0);
      shipmentsDeliveredArr.removeAt(0);
    });

    if (shipmentsStatusArr.length > 0) {
      if (shipmentsStatusArr[shipmentsArr.length - 1] != 'pending receive' &&
          shipmentsStatusArr[shipmentsArr.length - 1] != 'Done Receive' &&
          shipmentsStatusArr[shipmentsArr.length - 1] != 'For Put-away' &&
          shipmentsStatusArr[shipmentsArr.length - 1] != 'Pending Put-away') {
        getShipmentImage();
      } else {
        print('no image yet');
      }
    }

    print(shipmentsDepartedArr);

    items.first.numberItems =
        cartArr.length.toString() + ' ITEM/S IN YOUR CART';
  }

  getShipmentImage() async {
    print('proceed');
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef.child(
        'images/${shipmentsArr[shipmentsArr.length - 1].toString()}/${shipmentsArr[shipmentsArr.length - 1].toString()}_image_0.jpg');
    final url = await ref.getDownloadURL();

    // print(url);
    setState(() {
      shipmentImage = url;
    });
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

// // Routing
//   void pageController(int index) {
//     if (index == 0) {
//       context.push('/');
//     } else if (index == 1) {
//       context.push('/shipments');
//     } else if (index == 2) {
//       context.push('/cart');
//     } else if (index == 3) {
//       context.push('/newOrder');
//     }
//   }

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
                                      child: Text(
                                          "DENSO JAPAN IS HAVING A GIVEAWAY SALE\nHAPPENING NOW!\nSHOP NOW BEFORE STOCKS GO!",
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(children: [
                        SizedBox(height: 8.0),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                "Shipping Addresses",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ))
                      ]))),

              // Address Cards
              SizedBox(
                height: 250,
                child: ListView.separated(
                  padding: EdgeInsets.all(16),
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (context, _) => SizedBox(width: 20),
                  itemBuilder: (context, index) =>
                      buildCard(item: items[index]),
                ),
              ),

              SizedBox(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(children: [
                        SizedBox(height: 8.0),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Shipments",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    child: Text('View All'),
                                    onPressed: () {
                                      context.go('/shipments');
                                    },
                                  )
                                ]))
                      ]))),

              // Shipments Card
              shipmentsArr.length > 0
                  ? GestureDetector(
                      child: SizedBox(
                          child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          spreadRadius: .1,
                                          blurRadius: 15,
                                          offset: const Offset(-5, 5)),
                                    ],
                                  ),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              height: 120,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Pending Picking' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Done Picking' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Pending Packing' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Done Packing' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'To Ship'
                                                        ? Column(children: [
                                                            Container(
                                                              width: 70,
                                                              child:
                                                                  AutoSizeText(
                                                                'PREPARING FOR SHIPMENT',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxFontSize: 8,
                                                                minFontSize: 7,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ])
                                                        : shipmentsStatusArr[shipmentsArr.length - 1] ==
                                                                    'For Departed' ||
                                                                shipmentsStatusArr[shipmentsArr.length - 1] ==
                                                                    'Departed' ||
                                                                shipmentsStatusArr[shipmentsArr.length - 1] ==
                                                                    'Arrived' ||
                                                                shipmentsStatusArr[shipmentsArr.length - 1] ==
                                                                    'Warehouse Received' ||
                                                                shipmentsStatusArr[shipmentsArr.length - 1] ==
                                                                    'For Delivery'
                                                            ? Container(
                                                                width: 75,
                                                                child:
                                                                    AutoSizeText(
                                                                  'ON ITS WAY',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  maxFontSize:
                                                                      12,
                                                                  minFontSize:
                                                                      8,
                                                                  maxLines: 1,
                                                                ),
                                                              )
                                                            : shipmentsStatusArr[
                                                                        shipmentsArr.length - 1] ==
                                                                    'Done'
                                                                ? Container(
                                                                    width: 70,
                                                                    child:
                                                                        AutoSizeText(
                                                                      'DELIVERED',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      maxFontSize:
                                                                          12,
                                                                      minFontSize:
                                                                          8,
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                  )
                                                                : Container(),
                                                    SizedBox(height: 3),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        height: 75,
                                                        width: 70,
                                                        child: Image.network(
                                                            shipmentImage,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                  ]),
                                            ),

                                            SizedBox(width: 5),

                                            // Divider
                                            Column(
                                              children: [
                                                Container(
                                                  height: 120.0,
                                                  width: 5.0,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 10),

                                            // Column 2
                                            Container(
                                              width: 200,
                                              height: 110,
                                              child:
                                                  Column(
                                                children: [
                                                  // Tracking No & Delivery Date
                                                  Row(children: [
                                                    // If preparing, show tracking no
                                                    shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Pending Picking' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Done Picking' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Pending Packing' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'Done Packing' ||
                                                            shipmentsStatusArr[
                                                                    shipmentsArr.length -
                                                                        1] ==
                                                                'To Ship'
                                                        ? AutoSizeText(
                                                      shipmentsArr[
                                                          shipmentsArr.length -
                                                              1],
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      maxFontSize: 12,
                                                      minFontSize: 10,
                                                      maxLines: 1,
                                                    ) :
                                                    // Else show package no
                                                    AutoSizeText(
                                                      shipmentsPackageArr[
                                                          shipmentsArr.length -
                                                              1],
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      maxFontSize: 12,
                                                      minFontSize: 10,
                                                      maxLines: 1,
                                                    ),
                                                    Expanded(
                                                      child: Container(),
                                                    ),
                                                    AutoSizeText(
                                                      '15/07/2023',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                      maxFontSize: 12,
                                                      minFontSize: 11,
                                                      maxLines: 1,
                                                    ),
                                                  ]),
                                                  Expanded(child: Container()),
                                                  // Address
                                                  AutoSizeText(
                                                    '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto, Niño Parañaque City, 1704 Metro Manila \nPhone: TBA',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                    maxFontSize: 15,
                                                    minFontSize: 11,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                )
                              ]))),
                      onTap: () async {
                        shipmentsStatusArr[shipmentsArr.length - 1] ==
                                'pending receive'
                            ? showOrderDetails()
                            : goToItemPage();
                      })
                  : Text('No shipments'),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  goToItemPage() async {
    // Image
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef.child(
        'images/${shipmentsArr[shipmentsArr.length - 1].toString()}/${shipmentsArr[shipmentsArr.length - 1].toString()}_image_0.jpg');
    final url = await ref.getDownloadURL();

    // Days in storage
    var newDate =
        (DateFormat('yyyy, MM, dd').parse(dateStored[shipmentsArr.length - 1]));
    var newNow = (DateFormat('yyyy, MM, dd')
        .parse(dateCheckout[shipmentsArr.length - 1]));
    Duration difference = newNow.difference(newDate);
    daysInStorage = difference.inDays;
    var dateStoredParse =
        DateFormat('yyyy, MM, dd').parse(dateStored[shipmentsArr.length - 1]);
    var newDateStored = (DateFormat('dd, MM, yyyy').format(dateStoredParse));

    shipmentsStatusArr[shipmentsArr.length - 1] != 'pending receive' ||
            shipmentsStatusArr[shipmentsArr.length - 1] != 'Pending Put-away' ||
            shipmentsStatusArr[shipmentsArr.length - 1] != 'For Put-away' ||
            shipmentsStatusArr[shipmentsArr.length - 1] != 'Done Receive'
        ? Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemPage(
                  days: daysInStorage.toString(),
                  title: shipmentsArr[shipmentsArr.length - 1],
                  shipsFrom: 'PH Warehouse',
                  image: url,
                  storageFee: '-',
                  trackingNo: shipmentsArr[shipmentsArr.length - 1],
                  dateStored: newDateStored,
                )))
        : print('cannot access item page');
  }

  Future showOrderDetails() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              height: 370,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  Text('Order Details'),
                  SizedBox(height: 10),
                  Text('Tracking Number'),
                  SizedBox(height: 10),
                  Text(
                    shipmentsArr[shipmentsArr.length - 1],
                  ),
                  SizedBox(height: 15),
                  Text('Item Invoice Value'),
                  SizedBox(height: 10),
                  Text(
                    shipmentsValueArr[shipmentsArr.length - 1].toString(),
                  ),
                  SizedBox(height: 15),
                  Text('Notes | Special Instructions'),
                  SizedBox(height: 10),
                  Text(
                    shipmentsNotesArr[shipmentsArr.length - 1],
                  ),
                  SizedBox(height: 15),
                  Text('Bundle Type'),
                  SizedBox(height: 10),
                  Text(
                    shipmentsBundleArr[shipmentsArr.length - 1],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('CLOSE'),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 10),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder()),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));

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
