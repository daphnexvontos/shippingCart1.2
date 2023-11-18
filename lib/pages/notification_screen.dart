import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shipping_cart/pages/contact_page.dart';
import '../models/shipments.dart';
import '/pages/item_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var url;
  var urlArr = [];
  var accountNo;
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;
  var dateStoredPrep = [];
  var dateCheckoutPrep = [];
  var notificationsArr = [];
  var estDeliveryArr = [];
  var orderArray = [];
  var daysInStorage = [];
  var storageFeeArr = [];
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
            getDamaged();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future getDamaged() async {
    await db
        .collection("users")
        .doc(accountNo)
        .collection("damageNotif")
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        print(docSnapshot.data());
        //   // Date Stored
        //   int ts = docSnapshot.data()['storeDate'].millisecondsSinceEpoch;
        //   DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
        //   String dateTime = tsdate.year.toString() +
        //       "/" +
        //       tsdate.month.toString() +
        //       "/" +
        //       tsdate.day.toString();
        //   var date = DateFormat('yyyy/MM/dd').parse(dateTime);
        //   dateStoredPrep.add(DateFormat('dd/MM/yyyy').format(date));

        setState(() {
          notificationsArr.add(docSnapshot.data());
        });
        // } else {
        //   print('no items in preparing');
        // }
        // }
      }
    });
    
// for all notifications, get data for each tracking number
for (var i = 0; i < notificationsArr.length; i++) {
  print('notifs: ${notificationsArr[i]}');
        await db
            .collection("users")
            .doc(accountNo)
            .collection("TrackingNumber")
            .doc(notificationsArr[i]['trackingNumber'])
            .get()
            .then((DocumentSnapshot doc) {
          setState(() {
            final data = doc.data() as Map<String, dynamic>;
            print('data: ${data['trackingNumber']}');
            // // Image
            // final storageRef = FirebaseStorage.instance.ref();
            // final ref = storageRef.child(
            //     'images/${data['trackingNumber'].toString()}/${data['trackingNumber'].toString()}_image_0.jpg');
            // urlArr.add(ref.getDownloadURL());
            // print (urlArr);
          });
          // print('image: $urlArr');
        });

    // array of orders
    // for (var i = 0; i < notificationsArr.length; i++) {
      // url = urlArr[i];
      // orderArray.add(preparingArr[i].toString());
      // Image
      // final storageRef = FirebaseStorage.instance.ref();
      // final ref = storageRef.child(
      //     'images/${preparingArr[i]['trackingNumber'].toString()}/${preparingArr[i]['trackingNumber'].toString()}_image_0.jpg');
      // final url = await ref.getDownloadURL();

      // // Days in storage
      // var newDate = (DateFormat('dd/MM/yyyy').parse(dateStoredPrep[i]));
      // // var checkout = (DateFormat('dd/MM/yyyy').parse(dateCheckoutPrep[i]));
      // var today = DateTime.now();
      // Duration difference = today.difference(newDate);
      // daysInStorage.add(difference.inDays);

      // var newDateStored = (DateFormat('dd/MM/yyyy').format(newDate));

      // // if stored for more than 30 days, charge 5 per week
      // var daysExcess = 0.0;
      // if (difference.inDays > 30) {
      //   daysExcess += ((daysInStorage[i] - 30) / 7).ceil().toDouble();

      //   setState(() {
      //     storageFeeArr.add(daysExcess * 5);
      //   });
      // } else {
      //   setState(() {
      //     storageFeeArr.add(0.0);
      //   });
      // }

      preparing.add(Shipment(
          title: notificationsArr[i]['trackingNumber'],
          trackingNumber: notificationsArr[i]['trackingNumber'],
          days: '0',
          // difference.inDays.toString(),
          delivery: '-',
          estDelivery: '-',
          storageFee: 0,
          image: 'https://www.shippingcart.com/images/sc-icon.png',
          dateStored: 'test',
          value: 0,
          bundleType: 'test',
          notes: 'test'));
      // CheckBoxState(title: orderArr[i]['isChecked'].toString());
    }
    setState(() {
      preparing.removeAt(0);
    });
    return orderArray;
  }

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('NOTIFICATIONS'),
            automaticallyImplyLeading: false,
          ),
          body: preparing.length > 0
              ? Column(
                  children: [
                    Expanded(
                        child: ListView(children: [
                      ...preparing.map(buildPreparing).toList()
                    ]))
                  ],
                )
              : Center(
                  child: Text('No notifications', textAlign: TextAlign.center),
                ),
        ));
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
                    child: Column(
                      children: [
                        Row(
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
                                      'MARKED AS DAMAGED',
                                      textAlign: TextAlign.center,
                                      maxFontSize: 9,
                                      minFontSize: 8,
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.red),
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
                                      // child: Image.network(order.image,
                                      //     fit: BoxFit.cover),
                                    ),
                                  ),
                                ]),
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

                            // Column 2
                            SizedBox(width: 10),
                            Container(
                              width: 230,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.title),
                                  SizedBox(height: 10),
                                  Text(
                                      '$accountNo 2nd Floor, DSV Solutions Ninoy Aquino Ave, Bgy Sto. Niño, Parañaque City, 1704 Metro Manila\nPhone: TBA'),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: AutoSizeText(
                                  'Proceed',
                                  maxFontSize: 12,
                                  minFontSize: 11,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: ElevatedButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: const Size(75, 25),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: StadiumBorder()),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ContactPage()));
                                },
                                child: AutoSizeText(
                                  'Contact Customer Service',
                                  maxFontSize: 12,
                                  minFontSize: 10,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                style: ElevatedButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: const Size(75, 25),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: StadiumBorder()),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // Navigator.of(context).push(new MaterialPageRoute(
        //     builder: (context) => ItemPage(
        //           days: order.days,
        //           title: order.title,
        //           shipsFrom: 'PH Warehouse',
        //           image: order.image,
        //           storageFee: order.storageFee.toString(),
        //           trackingNo: order.trackingNumber,
        //           dateStored: order.dateStored,
        //         )));
      });
}

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Map payload={};
//     // get the notif and display on screen
//     final data = ModalRoute.of(context)!.settings.arguments;
//     if(data is RemoteMessage){
//       payload = data.data;
//     }
//     if(data is NotificationResponse){
//       payload = jsonDecode(data.payload!);
//     }

//     return Scaffold(
//         appBar: AppBar(title: Text('Notification')),
//         body: Center(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(payload.toString()),
//           ],
//         )));

        
        
//   }
// }