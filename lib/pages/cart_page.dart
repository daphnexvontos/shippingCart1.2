import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:shipping_cart/pages/landing_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../models/checkbox_state.dart';
import '../models/shipments.dart';
import 'item_page.dart';
import 'checkout_page.dart';
import '../widgets/navigation_menu.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final currentDate = DateTime.now();
  final email = FirebaseAuth.instance.currentUser!.email;
  var numItems = 0;
  var numItemsSelected = 0;
  final db = FirebaseFirestore.instance;
  final allOrders = CheckBoxState(
      title: 'Select All',
      toggle: [false, false],
      days: '0',
      itemValue: 0,
      image: 'https://www.shippingcart.com/images/sc-icon.png',
      storageFee: 0,
      shippingMethodBool: [true, false],
      trackingNo: '0',
      dateStored: '-');
  var orders = [
    CheckBoxState(
        title: 'test',
        toggle: [false, false],
        days: '0',
        itemValue: 0,
        image: 'https://www.shippingcart.com/images/sc-icon.png',
        storageFee: 0,
        shippingMethodBool: [true, false],
        trackingNo: '0',
        dateStored: '-')
  ];
  var toReceive = [
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
  var received = [
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
  var dateStored = [];
  var dateStoredItem = [];
  var daysInStorage = [];
  var daysInStorageItem = [];
  var itemValue = [];
  var itemValueItem = [];
  var imageArr = [];
  var imageArrItem = [];
  var orderArrId = ['0'];
  var orderArray = [];
  var orderReceivedArray = [];
  var orderData = [];
  var selectedShipping;
  var shipmentCost;
  var storageFee = 0.0;
  var storageFeeArr = [];
  var trackingNoArr = ['0'];
  var trackingNoArrItem = [];
  List<dynamic> shippingMethodArr = [];
  var shippingMethodSelected;
  var shippingMethodString;
  List<bool> shippingMethodBool = [false, false];
  var shippingMethodItem = [];
  var imageUrlArr = [];
  var saveTitle;
  var checkoutArr = [];
  var addressArr = [];
  var shipMethodArr = [];
  var shipSeaArr = [];
  var shipAirArr = [];
  var weightArr = [];
  var valueArr = [];
  var itemsForValuation = [];
  var chargeableWeight = 0.0;
  var airCargoRate = 0.0;
  var valuationFee = 0.0;
  var totalCargoFee = 0.0;
  var daysExcess = 0.0;
  var dateStoredForFee = [];
  var daysInStorageForFee = [];
  var toReceiveArr = [];
  var receivedArr = [];
  var shipmentsBundleArr = [];
  var shipmentsNotesArr = [];
  var shipmentsValueArr = [];
  var shipmentsStatusArr = ['-'];
  var accountNo;

  @override
  void initState() {
    super.initState();
    _getAccountNo();
  }

  Future<void> _getAccountNo() async {
    final allUsers = FirebaseFirestore.instance.collection("users");
    allUsers.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["email"] == email) {
            setState(() {
              accountNo = docSnapshot.data()['accountNo'];
            });
            getToReceive();
            getReceived();
            getOrderIds();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(accountNo);
  }

  Future getToReceive() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // print(docSnapshot.data());
        // done picking
        if (docSnapshot.data().containsValue('pending receive')) {
          setState(() {
            toReceiveArr.add(docSnapshot.data());
            shipmentsValueArr.add(docSnapshot.data()['invoiceValue']);
            shipmentsNotesArr.add(docSnapshot.data()['notes']);
            shipmentsBundleArr.add(docSnapshot.data()['bundleType']);
            shipmentsStatusArr.add(docSnapshot.data()['status'].toString());
          });
        } else {
          print('no items to be received');
        }
      }
    });
    // array of orders
    for (var i = 0; i < toReceiveArr.length; i++) {
      orderArray.add(toReceiveArr[i].toString());
      toReceive.add(Shipment(
          title: toReceiveArr[i]['trackingNumber'].toString(),
          trackingNumber: toReceiveArr[i]['trackingNumber'].toString(),
          days: '0',
          delivery: 'test',
          estDelivery: '-',
          image: 'https://www.shippingcart.com/images/sc-icon.png',
          storageFee: 0.0,
          dateStored: 'testing',
          value: toReceiveArr[i]['invoiceValue'],
          bundleType: toReceiveArr[i]['bundleType'],
          notes: toReceiveArr[i]['notes']));
      // CheckBoxState(title: orderArr[i]['isChecked'].toString());
    }
    setState(() {
      toReceive.removeAt(0);
    });
    return orderArray;
  }

  Future getReceived() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.data().containsValue('Done Receive') ||
            docSnapshot.data().containsValue('Pending Put-away') ||
            docSnapshot.data().containsValue('For Put-away')) {
          setState(() {
            receivedArr.add(docSnapshot.data());
            shipmentsValueArr.add(docSnapshot.data()['invoiceValue']);
            shipmentsNotesArr.add(docSnapshot.data()['notes']);
            shipmentsBundleArr.add(docSnapshot.data()['bundleType']);
            shipmentsStatusArr.add(docSnapshot.data()['status'].toString());
          });
        } else {
          print('no items to be received');
        }
      }
    });
    // array of orders
    for (var i = 0; i < receivedArr.length; i++) {
      orderReceivedArray.add(receivedArr[i].toString());
      received.add(Shipment(
          title: receivedArr[i]['trackingNumber'].toString(),
          trackingNumber: receivedArr[i]['trackingNumber'].toString(),
          days: '0',
          delivery: 'test',
          estDelivery: '-',
          image: 'https://www.shippingcart.com/images/sc-icon.png',
          storageFee: 0.0,
          dateStored: 'testing',
          value: receivedArr[i]['invoiceValue'],
          bundleType: receivedArr[i]['bundleType'],
          notes: receivedArr[i]['notes']));
      // CheckBoxState(title: orderArr[i]['isChecked'].toString());
    }
    setState(() {
      received.removeAt(0);
    });
    return orderReceivedArray;
  }

  Future getOrderIds() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("TrackingNumber")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // cart data
        if (docSnapshot.data().containsValue('Done Put-away')) {
          print('true');
          setState(() {
            // Tracking No
            trackingNoArr.add(docSnapshot.id);
            // Store Date
            int ts = docSnapshot.data()['storeDate'].millisecondsSinceEpoch;
            DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
            String dateTime = tsdate.year.toString() +
                "/" +
                tsdate.month.toString() +
                "/" +
                tsdate.day.toString();
            var date = DateFormat('yyyy/MM/dd').parse(dateTime);
            dateStored.add(DateFormat('dd/MM/yyyy').format(date));

            // Shipping Method
            shippingMethodString = (docSnapshot.data()['shipMethod']);
            shippingMethodSelected = (docSnapshot.data()['shipMethodSelected']);
            // if (shippingMethodString == 'air') {
            //   shippingMethodArr.add([true, false]);
            // } else if (shippingMethodString == 'sea') {
            //   shippingMethodArr.add([false, true]);
            // } else {
            //   if (shippingMethodSelected == 'air') {
            //     shippingMethodArr.add([true, false]);
            //   } else if (shippingMethodSelected == 'sea') {
            //     shippingMethodArr.add([false, true]);
            //   } else {
            //     shippingMethodArr.add([false, false]);
            //   }
            //   shippingMethodArr.add([false, false]);
            // }
            shippingMethodArr.add([true, false]);

            db
                .collection('users')
                .doc(accountNo)
                .collection('TrackingNumber')
                .doc(docSnapshot.id)
                .update({'shipMethodSelected': 'air'})
                .then((value) => {print('shipping method updated')})
                .catchError((error) => print(error));

            // Item Value
            itemValue.add(docSnapshot.data()['invoiceValue']);
          });
        }
      }
      trackingNoArr.removeAt(0);
    });

    // array of orders
    for (var i = 0; i < trackingNoArr.length; i++) {
      // Image
      final storageRef = FirebaseStorage.instance.ref();
      final ref = storageRef
          .child('images/${trackingNoArr[i]}/${trackingNoArr[i]}_image_0.jpg');
      final url = await ref.getDownloadURL();
      setState(() {
        imageUrlArr.add(url);
      });

      // Days in storage
      var newDate = (DateFormat('dd/MM/yyyy').parse(dateStored[i]));
      Duration difference = currentDate.difference(newDate);
      daysInStorage.add(difference.inDays);
      var dateStoredParse = DateFormat('dd/MM/yyyy').parse(dateStored[i]);
      var newDateStored = (DateFormat('dd/MM/yyyy').format(dateStoredParse));
      // if stored for more than 30 days, charge 5 per week
      daysExcess = 0;
      if (difference.inDays > 30) {
        daysExcess += ((daysInStorage[i] - 30) / 7).ceil().toDouble();
        print('excess: $daysExcess'); //in weeks

        setState(() {
          storageFeeArr.add(daysExcess * 5);
        });
      } else {
        setState(() {
          storageFeeArr.add(0.0);
        });
      }

      print(storageFeeArr);
      orders.add(
        CheckBoxState(
            title: trackingNoArr[i].toString(),
            toggle: [false, false],
            days: daysInStorage[i].toString(),
            storageFee: storageFeeArr[i],
            itemValue: itemValue[i].toDouble(),
            image: imageUrlArr[i],
            shippingMethodBool: shippingMethodArr[i],
            trackingNo: trackingNoArr[i],
            dateStored: newDateStored),
      );
    }
    setState(() {
      orders.removeAt(0);
    });
    numItems = orders.length;
    storageFeeArr = [];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: DefaultTabController(
            length: 3,
            child: SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        }, // Image tapped
                        child: Image(
                          image: AssetImage('assets/images/back_arrow.png'),
                          height: 24,
                          width: 24,
                          // color: Colors.red,
                        ),
                      ),
                      actions: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('FROM'),
                          ),
                        ),
                        // Philippines flag
                        Image(
                          image:
                              AssetImage('assets/images/philippines_flag.png'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('TO'),
                          ),
                        ),
                        // Australia flag
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Image(
                            image:
                                AssetImage('assets/images/australia_flag.png'),
                          ),
                        )
                      ],
                      backgroundColor: Colors.transparent,
                      elevation: 0,
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
                                          color:
                                              Theme.of(context).primaryColor)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      'ON THE WAY TO WH',
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
                                          color:
                                              Theme.of(context).primaryColor)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      'RECEIVED BY WH',
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
                                          color:
                                              Theme.of(context).primaryColor)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      'READY FOR CHECKOUT',
                                      maxFontSize: 11,
                                      minFontSize: 8,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )),
                            ),
                          ]),
                      flexibleSpace: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)))),
                    ),
                    body: TabBarView(children: [
                      // Tab 1 Cards
                      toReceive.length > 0
                          ? Column(
                              children: [
                                Expanded(
                                    child: ListView(children: [
                                  ...toReceive.map(buildToReceive).toList()
                                ]))
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.all(50),
                              child: Text(
                                  'No items to be received by warehouse',
                                  textAlign: TextAlign.center),
                            ),
                      // Tab 2 Cards
                      received.length > 0
                          ? Column(
                              children: [
                                Expanded(
                                    child: ListView(children: [
                                  ...received.map(buildReceived).toList()
                                ]))
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.all(50),
                              child: Text(
                                  'No items to be received by warehouse',
                                  textAlign: TextAlign.center),
                            ),

                      // Tab 3
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 100),
                            child: orders.length > 0
                                ? ListView(
                                    shrinkWrap: true,
                                    children: [
                                      buildGroupCheckbox(allOrders),
                                      ...orders
                                          .map(buildSingleCheckbox)
                                          .toList(),
                                    ],
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(50),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [Text('No items in cart')]),
                                  ),
                          ),
                          SlidingUpPanel(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            panel: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            width: 100,
                                            height: 5,
                                          ),
                                        ],
                                      ),

                                      // Air Cargo
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Air Cargo'),
                                          Text(
                                            '${shipAirArr.length.toString()} item/s',
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      Text('Estimated Delivery'),
                                      SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Chargeable Weight'),
                                          Text(
                                            '${chargeableWeight.toStringAsFixed(2)} kg/s',
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Air Cargo Rate'),
                                          SizedBox(width: 150),
                                          Text('x'),
                                          Text('20.00'),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(' '),
                                          Text(
                                              'AUD ${airCargoRate.toStringAsFixed(2)}'),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Fixed Handling Fee'),
                                          Text(
                                            "AUD 0",
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Valuation Fee'),
                                          SizedBox(width: 150),
                                          Text('+'),
                                          Text(valuationFee.toStringAsFixed(2)),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total Air Cargo Fee'),
                                          Text(
                                              totalCargoFee.toStringAsFixed(2)),
                                        ],
                                      ),
                                      SizedBox(height: 20),

                                      // Sea Cargo
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text("Sea Cargo"),
                                      //     Text(
                                      //       '${shipSeaArr.length.toString()} item/s',
                                      //       textAlign: TextAlign.end,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Text('Estimated Delivery'),
                                      // SizedBox(height: 30),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('Chargeable Weight'),
                                      //     Text(
                                      //       "0 kgs",
                                      //       textAlign: TextAlign.end,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('Sea Cargo Rate'),
                                      //     SizedBox(width: 150),
                                      //     Text('x'),
                                      //     Text("AUD 0"),
                                      //   ],
                                      // ),
                                      // Divider(
                                      //   color: Colors.black,
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(' '),
                                      //     Text("AUD 0"),
                                      //   ],
                                      // ),
                                      // SizedBox(height: 20),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('Fixed Handling Fee'),
                                      //     Text(
                                      //       "AUD 0",
                                      //       textAlign: TextAlign.end,
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('Valuation Fee'),
                                      //     SizedBox(width: 150),
                                      //     Text('+'),
                                      //     Text("AUD 0.00"),
                                      //   ],
                                      // ),
                                      // Divider(
                                      //   color: Colors.black,
                                      // ),
                                      // SizedBox(height: 10),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('Total Sea Cargo Fee'),
                                      //     Text("AUD 0"),
                                      //   ],
                                      // ),
                                      // SizedBox(height: 40),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Storage Fee'),
                                          Text(storageFee.toStringAsFixed(2)),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Shipment Cost'),
                                          Text('AUD ' +
                                              (totalCargoFee + storageFee)
                                                  .toStringAsFixed(2)),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                child: ElevatedButton(
                                              onPressed: () {
                                                // If address and shipMethodSelected are not empty
                                                checkIfUpdated();
                                              },
                                              child:
                                                  Text('PROCEED TO CHECKOUT'),
                                              style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      const Size(300, 10),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  foregroundColor: Colors.white,
                                                  shape: StadiumBorder()),
                                            )),
                                          ]),
                                    ],
                                  ),
                                )),

                            // collapsed text
                            collapsed: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Center(
                                child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              width: 100,
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Shipment Cost'),
                                            Text('AUD ' +
                                                (totalCargoFee + storageFee)
                                                    .toStringAsFixed(2)),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  child: ElevatedButton(
                                                onPressed: () {
                                                  // If address and shipMethodSelected are not empty
                                                  checkIfUpdated();
                                                },
                                                child:
                                                    Text('PROCEED TO CHECKOUT'),
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(300, 10),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: StadiumBorder()),
                                              )),
                                            ]),
                                      ],
                                    )),
                              ),
                            ),
                          )
                        ],
                      )
                    ])))));
  }

  Widget buildToReceive(Shipment order) => GestureDetector(
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
                                child: Text(
                                  'To',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 75,
                                child: Text(
                                  'receive',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Image
                              Container(
                                height: 70,
                                child: Image.asset('assets/images/shipment.png',
                                    fit: BoxFit.cover),
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
                              Row(children: [
                                Text(order.title),
                              ]),
                              SizedBox(height: 10),
                              Text(
                                  '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto. Niño, Parañaque City, 1704 Metro Manila\nPhone: TBA'),
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
      onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                content: Container(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Text('Order Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Tracking Number',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        order.title,
                      ),
                      SizedBox(height: 15),
                      Text('Item Invoice Value',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        order.value.toString(),
                      ),
                      SizedBox(height: 15),
                      Text('Notes | Special Instructions',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        order.notes,
                      ),
                      SizedBox(height: 15),
                      Text('Bundle Type',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        order.bundleType,
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
              )));

  Widget buildReceived(Shipment receivedOrder) => GestureDetector(
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
                                child: Text(
                                  'Received',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: 75,
                                child: Text(
                                  'By WH',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Image
                              Container(
                                height: 70,
                                child: Image.asset('assets/images/shipment.png',
                                    fit: BoxFit.cover),
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
                              Row(children: [
                                Text(receivedOrder.title),
                              ]),
                              SizedBox(height: 10),
                              Text(
                                  '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto. Niño, Parañaque City, 1704 Metro Manila\nPhone: TBA'),
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
      onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                content: Container(
                  height: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Text('Order Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Tracking Number',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        receivedOrder.title,
                      ),
                      SizedBox(height: 15),
                      Text('Item Invoice Value',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        receivedOrder.value.toString(),
                      ),
                      SizedBox(height: 15),
                      Text('Notes | Special Instructions',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        receivedOrder.notes,
                      ),
                      SizedBox(height: 15),
                      Text('Bundle Type',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                        receivedOrder.bundleType,
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
              )));

  Widget buildSingleCheckbox(CheckBoxState checkbox) => Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(children: [
        Container(
          width: 800,
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
              child: ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: checkbox.value,
                      subtitle: Container(
                          height: 150,
                          child: Row(children: [
                            // IMAGE
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                height: 110,
                                width: 60,
                                child: Image.network(checkbox.image,
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 10),
                            // CONTENT
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // title
                                  Row(children: [
                                    AutoSizeText(
                                      checkbox.title,
                                      maxFontSize: 15,
                                      minFontSize: 10,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                  SizedBox(height: 5),
                                  // days in storage
                                  Row(children: [
                                    AutoSizeText(
                                      'Days in PH Storage : ${checkbox.days.toString()}',
                                      maxFontSize: 15,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                  SizedBox(height: 5),
                                  // package value
                                  Row(children: [
                                    Container(
                                      width: 170,
                                      child: AutoSizeText(
                                        'Package Value : \$${checkbox.itemValue}',
                                        maxFontSize: 15,
                                        minFontSize: 11,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => ItemPage(
                                                    days: checkbox.days,
                                                    title: checkbox.title,
                                                    shipsFrom: 'PH Warehouse',
                                                    image: checkbox.image,
                                                    trackingNo:
                                                        checkbox.trackingNo,
                                                    dateStored:
                                                        checkbox.dateStored,
                                                    storageFee: checkbox
                                                        .storageFee
                                                        .toString())));
                                      },
                                      child: AutoSizeText(
                                        'Update',
                                        maxFontSize: 12,
                                        minFontSize: 11,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: const Size(75, 25),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: StadiumBorder()),
                                    ),
                                  ]),
                                  SizedBox(height: 5),

                                  // Shipment Method
                                  Row(children: [
                                    AutoSizeText(
                                      'Shipment Method',
                                      maxFontSize: 15,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 5),
                                    Text(':'),
                                    Container(
                                        height: 40,
                                        width: 80,
                                        color: Colors.transparent,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return ToggleButtons(
                                              fillColor: Colors.white,
                                              constraints:
                                                  BoxConstraints.expand(
                                                width: constraints.maxWidth / 2,
                                              ),
                                              renderBorder: false,
                                              isSelected:
                                                  checkbox.shippingMethodBool,
                                              children: <Widget>[
                                                GFCheckbox(
                                                  type: GFCheckboxType.circle,
                                                  activeBgColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  activeIcon: Transform.rotate(
                                                      angle: 45 * math.pi / 180,
                                                      child: Icon(Icons.flight,
                                                          color: Colors.white)),
                                                  onChanged: (value) {
                                                    print('checkbox clicked');
                                                  },
                                                  value: checkbox
                                                      .shippingMethodBool[0],
                                                  inactiveIcon:
                                                      Transform.rotate(
                                                          angle: 45 *
                                                              math.pi /
                                                              180,
                                                          child: Icon(
                                                              Icons.flight,
                                                              color: Colors
                                                                  .white)),
                                                  inactiveBgColor: Colors.grey,
                                                  inactiveBorderColor:
                                                      Colors.transparent,
                                                ),

                                                // Ship
                                                GFCheckbox(
                                                  type: GFCheckboxType.circle,
                                                  activeBgColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  activeIcon: Icon(
                                                      Icons.sailing,
                                                      color: Colors.white),
                                                  onChanged: (value) {
                                                    print('checkbox clicked');
                                                  },
                                                  value: checkbox
                                                      .shippingMethodBool[1],
                                                  inactiveIcon: Icon(
                                                      Icons.sailing,
                                                      color: Colors.white),
                                                  inactiveBgColor: Colors.grey,
                                                  inactiveBorderColor:
                                                      Colors.transparent,
                                                ),
                                              ],
                                              onPressed:
                                                  // single selection
                                                  (int) {
                                                print('toggle button pressed');
                                              });
                                        }))
                                  ])
                                ]),
                          ])),
                      onChanged: (value) {
                        setState(() {
                          checkbox.value = value!;
                          saveTitle = checkbox.title;
                          allOrders.value =
                              orders.every((order) => order.value == true);
                          if (checkbox.value == true) {
                            checkoutArr.add(checkbox.title);
                            valueArr.add(checkbox.itemValue);
                            numItemsSelected++;
                          } else {
                            // deselected
                            chargeableWeight = 0;
                            airCargoRate = 0;
                            valuationFee = 0;
                            totalCargoFee = 0;
                            storageFee = 0;
                            numItemsSelected--;
                            checkoutArr.removeWhere((str) {
                              return str == checkbox.title;
                            });
                            valueArr.removeWhere((str) {
                              return str == checkbox.itemValue;
                            });
                          }
                        });
                        checkShippingMethod();
                      }))),
        )
      ]));

  Widget buildGroupCheckbox(CheckBoxState checkbox) => CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: checkbox.value,
        title: Text(
            '${checkbox.title} | ${numItemsSelected.toString()} of ${numItems.toString()} item/s selected'),
        onChanged: toggleGroupCheckbox,
      );

  void toggleGroupCheckbox(bool? value) {
    checkoutArr = [];
    if (value == null) return;
    setState(() {
      allOrders.value = value;
      orders.forEach((order) {
        checkoutArr.add(order.title);
        // all will be selected
        order.value = value;
      });

      if (value == true) {
        numItemsSelected = orders.length;
      } else {
        checkoutArr = [];
        numItemsSelected = 0;
        chargeableWeight = 0;
        airCargoRate = 0;
        valuationFee = 0;
        totalCargoFee = 0;
        storageFee = 0;
      }
    });
    checkShippingMethod();
  }

  checkIfUpdated() async {
    shipMethodArr = [];
    addressArr = [];
    // for every item selected, check if receiver address and selected shipping have values
    for (var i = 0; i < checkoutArr.length; i++) {
      await db
          .collection('users')
          .doc(accountNo)
          .collection('TrackingNumber')
          .doc(checkoutArr[i])
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          setState(() {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('address')) {
              // print('true address');
              addressArr.add(data['address']);
            }
            if (data.containsKey('shipMethod')) {
              var value = data['shipMethod'];
              if (value == 'both') {
                if (data.containsKey('shipMethodSelected')) {
                  var selected = data['shipMethodSelected'];
                  if (selected == 'air') {
                    shipMethodArr.add(data['shipMethodSelected']);
                  } else if (selected == 'sea') {
                    shipMethodArr.add(data['shipMethodSelected']);
                  }
                }
              } else if (value == 'air') {
                shipMethodArr.add(data['shipMethod']);
              } else if (value == 'sea') {
                shipMethodArr.add(data['shipMethod']);
              }
            }
          });

          if (shipMethodArr.length == checkoutArr.length &&
              addressArr.length == checkoutArr.length) {
            // Proceed to next step
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CheckoutPage(
                      checkoutArr: checkoutArr,
                      shipAirArr: shipAirArr,
                      chargeableWeight: chargeableWeight,
                      airCargoRate: airCargoRate,
                      valuationFee: valuationFee,
                      totalCargoFee: totalCargoFee,
                      storageFee: storageFee,
                      // shipSeaArr: shipSeaArr,
                    )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please update recipient address')));
          }
        }
      });
    }
  }

  checkShippingMethod() async {
    shipAirArr = [];
    shipSeaArr = [];
    itemsForValuation = [];
    weightArr = [];
    daysInStorage = [];
    dateStoredForFee = [];

    for (var i = 0; i < checkoutArr.length; i++) {
      await db
          .collection('users')
          .doc(accountNo)
          .collection('TrackingNumber')
          .doc(checkoutArr[i])
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          setState(() {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('shipMethod')) {
              var value = data['shipMethod'];
              if (value == 'both') {
                if (data.containsKey('shipMethodSelected')) {
                  var selected = data['shipMethodSelected'];
                  if (selected == 'air') {
                    shipAirArr.add(data['shipMethodSelected']);
                  } else if (selected == 'sea') {
                    // shipSeaArr.add(data['shipMethodSelected']);
                    shipAirArr.add(data['shipMethodSelected']);
                  }
                }
              } else if (value == 'air') {
                shipAirArr.add(data['shipMethod']);
              } else if (value == 'sea') {
                shipAirArr.add(data['shipMethod']);
                // shipSeaArr.add(data['shipMethod']);
              }
            }
            // Package Value
            if (data.containsKey('invoiceValue')) {
              if (data['invoiceValue'] > 500) {
                itemsForValuation.add(data['invoiceValue']);
              } else {
                print('false');
              }
            }
            valuationFee = 0;
            for (var i = 0; i < itemsForValuation.length; i++) {
              setState(() {
                var valueFee = itemsForValuation[i] * 0.03;
                valuationFee += valueFee;
              });
            }

            // Weight
            if (data.containsKey('Length') &&
                data.containsKey('Width') &&
                data.containsKey('Height')) {
              var actualWeight = data['Weight'];
              var volumetricWeight =
                  (data['Length'] * data["Width"] * data["Height"]) / 5000;
              if (actualWeight > volumetricWeight) {
                weightArr.add(actualWeight);
              } else {
                weightArr.add(volumetricWeight);
              }
            }
            chargeableWeight = 0;
            for (var i = 0; i < weightArr.length; i++) {
              setState(() {
                chargeableWeight += weightArr[i];
                airCargoRate = chargeableWeight * 20;
              });
            }
            setState(() {
              totalCargoFee = valuationFee + airCargoRate;
            });

            // Days
            // Date
            int ts = data['dateReceive'].millisecondsSinceEpoch;
            DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
            String dateTime = tsdate.year.toString() +
                "/" +
                tsdate.month.toString() +
                "/" +
                tsdate.day.toString();
            var date = DateFormat('yyyy/MM/dd').parse(dateTime);
            dateStoredForFee.add(DateFormat('dd/MM/yyyy').format(date));
            daysInStorageForFee = [];

            // Days in storage
            for (var i = 0; i < dateStoredForFee.length; i++) {
              var newDate =
                  (DateFormat('dd/MM/yyyy').parse(dateStoredForFee[i]));
              Duration difference = currentDate.difference(newDate);
              daysInStorageForFee.add(difference.inDays);

              // if stored for more than 30 days, charge 5 per week
              daysExcess = 0;
              for (var i = 0; i < daysInStorageForFee.length; i++) {
                if (daysInStorageForFee[i] > 30) {
                  daysExcess +=
                      ((daysInStorageForFee[i] - 30) / 7).ceil().toDouble();
                  print('excess: $daysExcess');
                }
              }
              setState(() {
                storageFee = daysExcess * 5;
              });
            }
          });
        }
      });
    }
    // print('days: $daysInStorage');
  }
}
