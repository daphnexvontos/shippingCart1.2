import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../models/shipments.dart';
import '/pages/item_page.dart';
import '/pages/landing_page.dart';
import '/widgets/navigation_menu.dart';

class ShipmentsPage extends StatefulWidget {
  const ShipmentsPage({super.key});

  @override
  State<ShipmentsPage> createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  var accountNo;
  final currentDate = DateTime.now();
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;
  var dateCheckoutDel = [];
  var dateCheckoutPrep = [];
  var dateCheckoutOTW = [];
  var dateDel = [];
  var dateDeliveryArr = [];
  var dateDelivery;
  var dateStoredDel = [];
  var dateStoredPrep = [];
  var dateStoredOTW = [];
  var daysInStorage = [];
  var estDeliveryArr = [];
  var orderArr = [];
  var orderArray = [];
  var orders = [
    Shipment(
        title: 'test',
        trackingNumber: 'test',
        days: '0',
        delivery: 'test',
        estDelivery: '-',
        image: 'https://www.shippingcart.com/images/sc-icon.png',
        storageFee: 0.0,
        dateStored: 'test',
        value: 0,
        bundleType: 'test',
        notes: 'test')
  ];
  String phone = '';

  var preparing = [
    Shipment(
        title: 'test',
        trackingNumber: 'test',
        days: '0',
        delivery: 'test',
        estDelivery: '-',
        image: 'https://www.shippingcart.com/images/sc-icon.png',
        storageFee: 0.0,
        dateStored: 'test',
        value: 0,
        bundleType: 'test',
        notes: 'test')
  ];
  var onItsWay = [
    Shipment(
        title: 'test',
        trackingNumber: 'test',
        days: '0',
        delivery: 'test',
        estDelivery: '-',
        image: 'https://www.shippingcart.com/images/sc-icon.png',
        storageFee: 0.0,
        dateStored: 'test',
        value: 0,
        bundleType: 'test',
        notes: 'test')
  ];
  var delivered = [
    Shipment(
        title: 'test',
        trackingNumber: 'test',
        days: '0',
        delivery: 'test',
        estDelivery: '-',
        image: 'https://www.shippingcart.com/images/sc-icon.png',
        storageFee: 0.0,
        dateStored: 'test',
        value: 0,
        bundleType: 'test',
        notes: 'test')
  ];

  var preparingArr = [];
  var onItsWayArr = [];
  var deliveredArr = [];
  bool shouldPop = true;
  var shipmentsBundleArr = [];
  var shipmentsNotesArr = [];
  var shipmentsValueArr = [];
  var shipmentsStatusArr = ['-'];
  var storageFeeArr = [];
  var storageFeeArrOTW = [];
  var storageFeeArrDel = [];

  @override
  void initState() {
    super.initState();
    _getAccount();
  }

  Future<void> _getAccount() async {
    final allUsers = FirebaseFirestore.instance.collection("users");
    allUsers.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["email"] == email) {
            setState(() {
              accountNo = docSnapshot.data()['accountNo'];
            });
            getPreparing();
            getOnItsWay();
            getDelivered();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future getPreparing() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // done picking
        if (docSnapshot.data().containsValue('Pending Picking') ||
            docSnapshot.data().containsValue('Done Picking') ||
            docSnapshot.data().containsValue('Pending Packing') ||
            docSnapshot.data().containsValue('Done Packing') ||
            docSnapshot.data().containsValue('To Ship')) {
          // Date Stored
          int ts = docSnapshot.data()['storeDate'].millisecondsSinceEpoch;
          DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
          String dateTime = tsdate.year.toString() +
              "/" +
              tsdate.month.toString() +
              "/" +
              tsdate.day.toString();
          var date = DateFormat('yyyy/MM/dd').parse(dateTime);
          dateStoredPrep.add(DateFormat('dd/MM/yyyy').format(date));

          // Date Checkout
          int tsCheckout =
              docSnapshot.data()['dateCheckout'].millisecondsSinceEpoch;
          print(tsCheckout);
          DateTime tsdateCheckout =
              DateTime.fromMillisecondsSinceEpoch(tsCheckout);
          print(tsdateCheckout);
          String dateTimeCheckout = tsdateCheckout.year.toString() +
              "/" +
              tsdateCheckout.month.toString() +
              "/" +
              tsdateCheckout.day.toString();
          var dateCheckout = DateFormat('yyyy/MM/dd').parse(dateTimeCheckout);
          dateCheckoutPrep.add(DateFormat('dd/MM/yyyy').format(dateCheckout));

          setState(() {
            preparingArr.add(docSnapshot.data());
          });

          // Estimated Delivery Date
          DateTime estDelivery = tsdateCheckout.add(Duration(days: 15));
          String estDeliveryString = estDelivery.year.toString() +
              "/" +
              estDelivery.month.toString() +
              "/" +
              estDelivery.day.toString();
          ;
          var dateEstimate = DateFormat('yyyy/MM/dd').parse(estDeliveryString);
          estDeliveryArr.add(DateFormat('dd/MM/yyyy').format(dateEstimate));
        } else {
          print('no items in preparing');
        }
      }
    });
    // array of orders
    for (var i = 0; i < preparingArr.length; i++) {
      orderArray.add(preparingArr[i].toString());
      // Image
      final storageRef = FirebaseStorage.instance.ref();
      final ref = storageRef.child(
          'images/${preparingArr[i]['trackingNumber'].toString()}/${preparingArr[i]['trackingNumber'].toString()}_image_0.jpg');
      final url = await ref.getDownloadURL();

      // Days in storage
      var newDate = (DateFormat('dd/MM/yyyy').parse(dateStoredPrep[i]));
      var checkout = (DateFormat('dd/MM/yyyy').parse(dateCheckoutPrep[i]));
      Duration difference = checkout.difference(newDate);
      daysInStorage.add(difference.inDays);

      var newDateStored = (DateFormat('dd/MM/yyyy').format(newDate));

      // Est Delivery Date
      var deliveryDate = estDeliveryArr[i];

      // if stored for more than 30 days, charge 5 per week
      var daysExcess = 0.0;
      if (difference.inDays > 30) {
        daysExcess += ((daysInStorage[i] - 30) / 7).ceil().toDouble();

        setState(() {
          storageFeeArr.add(daysExcess * 5);
        });
      } else {
        setState(() {
          storageFeeArr.add(0.0);
        });
      }

      preparing.add(Shipment(
          title: preparingArr[i]['trackingNumber'],
          trackingNumber: preparingArr[i]['trackingNumber'],
          days: difference.inDays.toString(),
          delivery: '-',
          estDelivery: deliveryDate,
          storageFee: storageFeeArr[i],
          image: url,
          dateStored: newDateStored,
          value: preparingArr[i]['invoiceValue'],
          bundleType: preparingArr[i]['bundleType'],
          notes: preparingArr[i]['notes']));
      // CheckBoxState(title: orderArr[i]['isChecked'].toString());
    }
    setState(() {
      preparing.removeAt(0);
    });
    return orderArray;
  }

  Future getOnItsWay() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.data().containsValue('For Departed') ||
            docSnapshot.data().containsValue('Departed') ||
            docSnapshot.data().containsValue('Arrived') ||
            docSnapshot.data().containsValue('Warehouse Received') ||
            docSnapshot.data().containsValue('For Delivery') ||
            (docSnapshot.data().containsValue('Done') &&
                !docSnapshot.data().containsKey('sdeliveredDate'))) {
          // Date Stored
          int ts = docSnapshot.data()['storeDate'].millisecondsSinceEpoch;
          DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
          String dateTime = tsdate.year.toString() +
              "/" +
              tsdate.month.toString() +
              "/" +
              tsdate.day.toString();
          var date = DateFormat('yyyy/MM/dd').parse(dateTime);
          dateStoredOTW.add(DateFormat('dd/MM/yyyy').format(date));

          // Date Checkout
          int tsCheckout =
              docSnapshot.data()['dateCheckout'].millisecondsSinceEpoch;
          print(tsCheckout);
          DateTime tsdateCheckout =
              DateTime.fromMillisecondsSinceEpoch(tsCheckout);
          print(tsdateCheckout);
          String dateTimeCheckout = tsdateCheckout.year.toString() +
              "/" +
              tsdateCheckout.month.toString() +
              "/" +
              tsdateCheckout.day.toString();
          var dateCheckout = DateFormat('yyyy/MM/dd').parse(dateTimeCheckout);
          dateCheckoutOTW.add(DateFormat('dd/MM/yyyy').format(dateCheckout));

          // Date Delivered
          int tsDel = docSnapshot.data()['etdSydney'].millisecondsSinceEpoch;
          print(tsDel);
          DateTime tsdateDel = DateTime.fromMillisecondsSinceEpoch(tsDel);
          print(tsdateDel);
          String dateTimeDel = tsdateDel.year.toString() +
              "/" +
              tsdateDel.month.toString() +
              "/" +
              tsdateDel.day.toString();
          var dateDel = DateFormat('yyyy/MM/dd').parse(dateTimeDel);
          dateDeliveryArr.add(DateFormat('dd/MM/yyyy').format(dateDel));

          // Estimated Delivery Date
          DateTime estDelivery = tsdateCheckout.add(Duration(days: 15));
          String estDeliveryString = estDelivery.year.toString() +
              "/" +
              estDelivery.month.toString() +
              "/" +
              estDelivery.day.toString();
          ;
          var dateEstimate = DateFormat('yyyy/MM/dd').parse(estDeliveryString);
          estDeliveryArr.add(DateFormat('dd/MM/yyyy').format(dateEstimate));

          // add to on its way tab
          setState(() {
            onItsWayArr.add(docSnapshot.data());
          });
        }
      }
    });
    // array of orders
    for (var i = 0; i < onItsWayArr.length; i++) {
      // Image
      final storageRef = FirebaseStorage.instance.ref();
      final ref = storageRef.child(
          'images/${onItsWayArr[i]['trackingNumber'].toString()}/${onItsWayArr[i]['trackingNumber'].toString()}_image_0.jpg');
      final url = await ref.getDownloadURL();

      // Days in storage
      var newDate = (DateFormat('dd/MM/yyyy').parse(dateStoredOTW[i]));
      var checkout = (DateFormat('dd/MM/yyyy').parse(dateCheckoutOTW[i]));
      Duration difference = checkout.difference(newDate);

      var newDateStored = (DateFormat('dd/MM/yyyy').format(newDate));

      dateDelivery = dateDeliveryArr[i];
      orderArray.add(onItsWayArr[i].toString());

      // Est Delivery Date
      var deliveryDate = estDeliveryArr[i];

      // if stored for more than 30 days, charge 5 per week
      var daysExcessOTW = 0.0;
      if (difference.inDays > 30) {
        daysExcessOTW += ((daysInStorage[i] - 30) / 7).ceil().toDouble();
        print('excess: $daysExcessOTW'); //in weeks

        setState(() {
          storageFeeArrOTW.add(daysExcessOTW * 5);
        });
      } else {
        setState(() {
          storageFeeArrOTW.add(0.0);
        });
      }

      onItsWay.add(Shipment(
          title: onItsWayArr[i]['packageNumber'],
          trackingNumber: onItsWayArr[i]['trackingNumber'],
          days: difference.inDays.toString(),
          delivery: dateDelivery,
          estDelivery: deliveryDate,
          image: url,
          storageFee: storageFeeArrOTW[i],
          dateStored: newDateStored,
          value: onItsWayArr[i]['invoiceValue'],
          bundleType: onItsWayArr[i]['bundleType'],
          notes: onItsWayArr[i]['notes']));
    }
    setState(() {
      onItsWay.removeAt(0);
    });
    return orderArray;
  }

  Future getDelivered() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.data().containsKey('sdeliveredDate')) {
          // Date Stored
          int ts = docSnapshot.data()['storeDate'].millisecondsSinceEpoch;
          DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
          String dateTime = tsdate.year.toString() +
              "/" +
              tsdate.month.toString() +
              "/" +
              tsdate.day.toString();
          var date = DateFormat('yyyy/MM/dd').parse(dateTime);
          dateStoredDel.add(DateFormat('dd/MM/yyyy').format(date));

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
          var dateCheckout = DateFormat('yyyy/MM/dd').parse(dateTimeCheckout);
          dateCheckoutDel.add(DateFormat('dd/MM/yyyy').format(dateCheckout));

          // Date Delivered
          int tsDelivered =
              docSnapshot.data()['sdeliveredDate'].millisecondsSinceEpoch;
          DateTime tsdateDelivered =
              DateTime.fromMillisecondsSinceEpoch(tsDelivered);
          String dateTimeDelivered = tsdateDelivered.year.toString() +
              "/" +
              tsdateDelivered.month.toString() +
              "/" +
              tsdateDelivered.day.toString();
          var dateDelivered = DateFormat('yyyy/MM/dd').parse(dateTimeDelivered);
          dateDel.add(DateFormat('dd/MM/yyyy').format(dateDelivered));

          // DateTime estDelivery = tsdateCheckout.add(Duration(days: 15));
          // String estDeliveryString = estDelivery.year.toString() +
          //     "/" +
          //     estDelivery.month.toString() +
          //     "/" +
          //     estDelivery.day.toString();
          // ;
          // var dateEstimate = DateFormat('yyyy/MM/dd').parse(estDeliveryString);
          // estDeliveryArr.add(DateFormat('yyyy, MM, dd').format(dateEstimate));

          // add to delivered tab
          setState(() {
            deliveredArr.add(docSnapshot.data());
          });
        }
      }
    });
    // array of orders
    for (var i = 0; i < deliveredArr.length; i++) {
      // Image
      final storageRef = FirebaseStorage.instance.ref();
      final ref = storageRef.child(
          'images/${deliveredArr[i]['trackingNumber'].toString()}/${deliveredArr[i]['trackingNumber'].toString()}_image_0.jpg');
      final url = await ref.getDownloadURL();

      // Days in storage
      var newDate = (DateFormat('dd/MM/yyyy').parse(dateStoredDel[i]));
      var checkout = (DateFormat('dd/MM/yyyy').parse(dateCheckoutDel[i]));
      Duration difference = checkout.difference(newDate);

      var newDateStored = (DateFormat('dd/MM/yyyy').format(newDate));

      // Delivery Date
      var deliveryDate = dateDel[i];
      print(deliveryDate);

      orderArray.add(deliveredArr[i].toString());

      // if stored for more than 30 days, charge 5 per week
      var daysExcessDel = 0.0;
      if (difference.inDays > 30) {
        daysExcessDel += ((daysInStorage[i] - 30) / 7).ceil().toDouble();
        print('excess: $daysExcessDel'); //in weeks

        setState(() {
          storageFeeArrDel.add(daysExcessDel * 5);
        });
      } else {
        setState(() {
          storageFeeArrDel.add(0.0);
        });
      }

      delivered.add(Shipment(
          title: deliveredArr[i]['packageNumber'],
          trackingNumber: deliveredArr[i]['trackingNumber'],
          days: difference.inDays.toString(),
          delivery: '-',
          estDelivery: deliveryDate,
          image: url,
          storageFee: storageFeeArrDel[i],
          dateStored: newDateStored,
          value: deliveredArr[i]['invoiceValue'],
          bundleType: deliveredArr[i]['bundleType'],
          notes: deliveredArr[i]['notes']));
      // CheckBoxState(title: orderArr[i]['isChecked'].toString());
    }
    setState(() {
      delivered.removeAt(0);
    });
    return orderArray;
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
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // Routing
  void pageController(int index) {
    if (index == 0) {
      context.push('/');
    } else if (index == 1) {
      context.push('/shipments');
    } else if (index == 2) {
      context.push('/cart');
    } else if (index == 3) {
      context.push('/newOrder');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              // bottomNavigationBar: BottomNavBar(
              //   index: 1,
              //   configs: navbarConfigs,
              //   onTap: (index) {
              //     pageController(index);
              //   },
              // ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('SHIPMENTS'),
                automaticallyImplyLeading: false,
                bottom: TabBar(
                  labelPadding: EdgeInsets.all(5),
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.only(top: 5, bottom: 5),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor,
                  ),
                  labelStyle: TextStyle(fontSize: 12),
                  tabs: [
                    Tab(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              'PREPARING',
                              maxFontSize: 11,
                              minFontSize: 8,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ),
                    Tab(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              'ON ITS WAY',
                              maxFontSize: 11,
                              minFontSize: 8,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ),
                    Tab(
                      child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              'DELIVERED',
                              maxFontSize: 11,
                              minFontSize: 8,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // Tab 1 Cards
                  preparing.length > 0
                      ? Column(
                          children: [
                            Expanded(
                                child: ListView(children: [
                              ...preparing.map(buildPreparing).toList()
                            ]))
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(50),
                          child: Text('No shipments being processed',
                              textAlign: TextAlign.center),
                        ),

                  // Tab 2 Cards
                  onItsWay.length > 0
                      ? Column(
                          children: [
                            Expanded(
                                child: ListView(children: [
                              ...onItsWay.map(buildOnItsWay).toList()
                            ]))
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(50),
                          child: Text('No shipments on its way',
                              textAlign: TextAlign.center),
                        ),

                  // Tab 3 Cards
                  delivered.length > 0
                      ? Column(
                          children: [
                            Expanded(
                                child: ListView(children: [
                              ...delivered.map(buildDelivered).toList()
                            ]))
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(50),
                          child: Text('No shipments delivered',
                              textAlign: TextAlign.center),
                        ),
                ],
              ),
            )));
  }

  Widget buildPreparing(Shipment order) => GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
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
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Status
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 75,
                                child: AutoSizeText(
                                  'PREPARING FOR SHIPMENT',
                                  textAlign: TextAlign.center,
                                  maxFontSize: 9,
                                  minFontSize: 8,
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(height: 3),
                              // Preparing Image
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 80,
                                  width: 70,
                                  child: Image.network(order.image,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ]),
                        SizedBox(width: 5),

                        // Divider
                        Column(
                          children: [
                            Container(
                              height: 140.0,
                              width: 5.0,
                              color: Colors.grey,
                            )
                          ],
                        ),

                        // Column 2
                        SizedBox(width: 10),
                        Container(
                          width: 230,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(order.title),
                              ]),
                              SizedBox(height: 10),
                              Text(
                                  '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto. Niño, Parañaque City, 1704 Metro Manila\nPhone: TBA'),
                              SizedBox(height: 10),
                              Text(
                                  'Estimated delivery date: ${order.estDelivery}',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => ItemPage(
                  days: order.days,
                  title: order.title,
                  shipsFrom: 'PH Warehouse',
                  image: order.image,
                  storageFee: order.storageFee.toString(),
                  trackingNo: order.trackingNumber,
                  dateStored: order.dateStored,
                )));
      });

  Widget buildOnItsWay(Shipment orderOnItsWay) => GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
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
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Status
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 75,
                                  child: AutoSizeText(
                                    'ON ITS WAY',
                                    textAlign: TextAlign.center,
                                    maxFontSize: 14,
                                    minFontSize: 12,
                                    maxLines: 2,
                                  )),
                              SizedBox(height: 10),
                              // On Its Way Image
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 80,
                                  width: 70,
                                  child: Image.network(orderOnItsWay.image,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ]),
                        SizedBox(width: 5),
                        Column(
                          children: [
                            Container(
                              height: 140.0,
                              width: 5.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 230,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(orderOnItsWay.title),
                              const SizedBox(width: 8),
                              SizedBox(height: 10),
                              Text(
                                  '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto. Niño, Parañaque City, 1704 Metro Manila\nPhone: TBA'),
                              SizedBox(height: 10),
                              Text(
                                  'Estimated delivery date: ${orderOnItsWay.estDelivery}',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => ItemPage(
                  days: orderOnItsWay.days,
                  title: orderOnItsWay.title,
                  shipsFrom: 'PH Warehouse',
                  image: orderOnItsWay.image,
                  storageFee: orderOnItsWay.storageFee.toString(),
                  trackingNo: orderOnItsWay.trackingNumber,
                  dateStored: orderOnItsWay.dateStored,
                )));
      });

  Widget buildDelivered(Shipment orderDelivered) => GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
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
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Status
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 75,
                                child: AutoSizeText(
                                  'DELIVERED',
                                  textAlign: TextAlign.center,
                                  maxFontSize: 14,
                                  minFontSize: 10,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 3),
                              // On Its Way Image
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 80,
                                  width: 70,
                                  child: Image.network(orderDelivered.image,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ]),
                        SizedBox(width: 5),
                        Column(
                          children: [
                            Container(
                              height: 140.0,
                              width: 5.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(width: 10),
                        // Column 2
                        Container(
                          width: 230,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(orderDelivered.title),
                              const SizedBox(width: 8),
                              SizedBox(height: 10),
                              Text(
                                  '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto. Niño, Parañaque City, 1704 Metro Manila\nPhone: TBA'),
                              SizedBox(height: 10),
                              Text(
                                  'Date delivered: ${orderDelivered.estDelivery}',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => ItemPage(
                  days: orderDelivered.days,
                  title: orderDelivered.title,
                  shipsFrom: 'PH Warehouse',
                  storageFee: orderDelivered.storageFee.toString(),
                  image: orderDelivered.image,
                  trackingNo: orderDelivered.trackingNumber,
                  dateStored: orderDelivered.dateStored,
                )));
      });
}
