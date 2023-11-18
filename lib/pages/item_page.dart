import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/addresses.dart';
import '../models/items.dart';
import '/pages/cart_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({
    Key? key,
    required this.days,
    required this.title,
    required this.shipsFrom,
    required this.image,
    required this.storageFee,
    required this.trackingNo,
    required this.dateStored,
  }) : super(key: key);

  final String days;
  final String title;
  final String shipsFrom;
  final String storageFee;
  final String image;
  final String dateStored;
  final String trackingNo;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  var currentDate = DateTime.now();
  final packageValueController = TextEditingController();
  final newNameController = TextEditingController();
  final newAddressController = TextEditingController();
  final newPhoneNoController = TextEditingController();
  final searchController = TextEditingController();

  var packageValue;
  final db = FirebaseFirestore.instance;
  var itemData = [];
  var shop;
  List<bool> shippingMethodBool = [false, false];
  var length;
  var width;
  var height;
  var shippingMethodString;
  var shippingMethodSelected;
  var dimensions;
  var itemFrom;
  var item = Items(
    seller: 'test',
    shippingMethodBool: [false, false],
  );
  var address = [Address(name: 'test', address: 'test', phoneNo: '0', id: '0')];
  var name = [];
  var addressArr = [];
  var addressLength = 0;
  var phone = [];
  var foundUsers = [];
  var recipient = ' ';
  var recipientDetails = 'Select receiver address';
  var selectedShipping;
  var image1 = 'https://www.shippingcart.com/images/sc-icon.png';
  var image2 = 'https://www.shippingcart.com/images/sc-icon.png';
  var image3 = 'https://www.shippingcart.com/images/sc-icon.png';
  var addressId = [];
  var status;
  var accountNo;

  @override
  void initState() {
    super.initState();
    _getAccountNo();
    foundUsers = address;
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
            getOrderIds();
            getAddresses();
            getRecipient();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    print(accountNo);
  }

  getAddresses() {
    db
        .collection("users")
        .doc(accountNo)
        .collection('addresses')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        setState(() {
          addressLength = querySnapshot.docs.length;
          name.add(docSnapshot.data()['Name']);
          phone.add(docSnapshot.data()['Phone No']);
          addressArr.add(docSnapshot.data()['Address']);
          addressId.add(docSnapshot.id);
        });
      }
      (e) => print("Error completing: $e");
    });

    // array of orders
    for (var i = 0; i < addressLength; i++) {
      if (address.length < addressLength) {
        address.add(Address(
            name: name[i].toString(),
            address: addressArr[i].toString(),
            phoneNo: phone[i].toString(),
            id: addressId[i].toString()));
      }
      // CheckBoxState(title: orderArr[i]['isChecked'].toString());
    }
    // print(address);
    address.removeWhere((item) => item.name == 'test');
    foundUsers = address;
  }

  // Get item info
  Future getOrderIds() async {
    await db
        .collection('users')
        .doc(accountNo)
        .collection('TrackingNumber')
        .doc(widget.trackingNo)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        setState(() {
          final data = doc.data() as Map<String, dynamic>;
          // dimensions
          length = (data['Length']).round();
          width = (data['Width']).round();
          height = (data['Height']).round();

          // shipping method
          // shippingMethodString = (data['shipMethod']);
          // shippingMethodSelected = (data['shipMethodSelected']);
          // if (shippingMethodString.toLowerCase() == 'air') {
          //   selectedShipping = 0;
          // } else if (shippingMethodString.toLowerCase() == 'sea') {
          //   selectedShipping = 1;
          // } else {
          //   if (shippingMethodSelected == 'air') {
          //     selectedShipping = 0;
          //   } else if (shippingMethodSelected == 'sea') {
          //     selectedShipping = 1;
          //   } else {
          //     selectedShipping = null;
          //   }
          // }
          selectedShipping = 0;

          // package value
          packageValue = data['invoiceValue'];

          // status
          status = data['status'];
        });
      }
    });
    item = Items(
      seller: '-',
      shippingMethodBool: shippingMethodBool,
    );
    // Image
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef
        .child('images/${widget.trackingNo}/${widget.trackingNo}_image_1.jpg');
    final url = await ref.getDownloadURL();
    final ref2 = storageRef
        .child('images/${widget.trackingNo}/${widget.trackingNo}_image_2.jpg');
    final url2 = await ref2.getDownloadURL();
    final ref3 = storageRef
        .child('images/${widget.trackingNo}/${widget.trackingNo}_image_3.jpg');
    final url3 = await ref3.getDownloadURL();
    setState(() {
      image1 = url;
      image2 = url2;
      image3 = url3;
    });
  }
  // onError: (e) => print('Error getting document: $e'),

  getRecipient() {
    db
        .collection('users')
        .doc(accountNo)
        .collection('TrackingNumber')
        .doc(widget.trackingNo)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        setState(() {
          final data = doc.data() as Map<String, dynamic>;
          // find in address book
          db
              .collection("users")
              .doc(accountNo)
              .collection('addresses')
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              if (docSnapshot.id == data['address']) {
                setState(() {
                  recipient = "${docSnapshot.data()['Name']}";
                  recipientDetails =
                      "${docSnapshot.data()['Address']}\n${docSnapshot.data()['Phone No']}";
                });
              }
            }
          });
        });
      }
    });
    // onError: (e) => print('Error getting document: $e'),
  }

  updateOrderValue(newValue) {
    db
        .collection('users')
        .doc(accountNo)
        .collection('TrackingNumber')
        .doc(widget.trackingNo)
        .update({'invoiceValue': double.parse(newValue)})
        .then((value) => {print('value updated')})
        .catchError((error) => print(error));
  }

  // updateShippingPlane() {
  //   db
  //       .collection('users')
  //       .doc(email)
  //       .collection('TrackingNumber')
  //       .doc(widget.trackingNo)
  //       .update({'shipMethodSelected': 'air'})
  //       .then((value) => {print('shipping method updated')})
  //       .catchError((error) => print(error));
  // }

  // updateShippingShip() {
  //   db
  //       .collection('users')
  //       .doc(email)
  //       .collection('TrackingNumber')
  //       .doc(widget.trackingNo)
  //       .update({'shipMethodSelected': 'sea'})
  //       .then((value) => {print('shipping method updated')})
  //       .catchError((error) => print(error));
  // }

  addAddress(newName, newAddress, newPhoneNo) {
    db
        .collection('users')
        .doc(accountNo)
        .collection('addresses')
        .add({'Name': newName, 'Address': newAddress, 'Phone No': newPhoneNo});
  }

  updateRecipient(recipientAddress) async {
    await db
        .collection('users')
        .doc(accountNo)
        .collection('TrackingNumber')
        .doc(widget.trackingNo)
        .update({'address': recipientAddress})
        .then((value) => {print('recipient address updated')})
        .catchError((error) => print(error));
  }

  runFilter(String enteredKeyword) {
    var results = [
      Address(
        name: 'test',
        address: 'test',
        phoneNo: '0',
        id: '0',
      )
    ];
    if (enteredKeyword.isEmpty) {
      results = address;
    } else {
      results = address
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      foundUsers = results;
    });
  }

  // Get current user info
  final user = FirebaseAuth.instance.currentUser!;
  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    packageValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child:
    SafeArea(
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
                child: Text('Item Page', style: TextStyle(fontSize: 25)),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    // move to left
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(widget.title),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 10),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: StadiumBorder()),
                    ),
                  ),
                ),
              )),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)))),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                  // Item Overview Card
                  child: singleItem(item)),

              // Package Value
              Container(
                width: 800,
                height: 60,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Package Value'),
                          SizedBox(width: 10),
                          Container(
                            child: Row(children: [
                              Text('AUD ' + packageValue.toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                onPressed: () => status == 'Done Put-away'
                                    ? openPackageValueDialog()
                                    : print('cannot edit'),
                                icon: Icon(Icons.edit),
                                iconSize: 20,
                                color: Colors.grey,
                              )
                            ]),
                          )
                        ],
                      )),
                ),
              ),

              // Shipping Method
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
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        width: 250,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping Method'),
                              // Radio buttons
                              Row(children: [
                                Container(
                                  child: CustomShippingMethodButton(0xe297, 0),
                                  width: 38,
                                ),
                                SizedBox(width: 10),
                                Container(
                                  child: CustomShippingMethodButton(0xe54d, 1),
                                  width: 38,
                                ),
                              ])
                            ]),
                      )),
                ),
              ),

              // Days in Storage & Storage Fee
              Container(
                  child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // Days in Storage
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
                                    child: Container(
                                      child: Row(children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              child: Image.asset(
                                                  'assets/images/days_in_storage.png'),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: 110,
                                              child: AutoSizeText(
                                                'Days in Storage',
                                                maxFontSize: 15,
                                                minFontSize: 10,
                                                maxLines: 1,
                                              ),
                                            ),
                                            Text(widget.days,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )
                                      ]),
                                    )))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // Storage Fee
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
                                    child: Container(
                                      child: Row(children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              child: Image.asset(
                                                  'assets/images/storage_fee.png'),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 110,
                                              child: AutoSizeText(
                                                'Storage Fee',
                                                maxFontSize: 15,
                                                minFontSize: 10,
                                                maxLines: 1,
                                              ),
                                            ),
                                            Text(widget.storageFee,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )
                                      ]),
                                    )))),
                      ],
                    ),
                  ),
                ],
              )),

              Container(
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text('Select Shipping Address')],
                      ))),

              // Select Shipping Address
              GestureDetector(
                onTap: () {
                  status == 'Done Put-away'
                      ? openAddressesDialog()
                      : print('cannot edit');
                  getAddresses();
                },
                child: Container(
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
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Info
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                recipient.toString() != ' '
                                    ? Text(recipient.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                    : Container(),
                                Text(recipientDetails.toString()),
                              ],
                            )),
                            Icon(
                              Icons.import_contacts,
                              size: 50,
                              color: Colors.black,
                            )
                          ],
                        )),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    ));
  }

// DIALOG BOXES
// Pop up package value dialog
  Future openPackageValueDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text('Package Value'),
                  SizedBox(height: 10),
                  Text(
                      'Minimum package value allowed is up to AUD 5,000.00 per package'),
                  SizedBox(height: 10),
                  Text('What is declared value and why is it important?'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('AU\$'),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          controller: packageValueController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '0.00',
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          updateOrderValue(packageValueController.text);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      this.widget));
                        },
                        child: Text('CONFIRM'),
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

// Pop up addresses dialog
  Future openAddressesDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
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
                            ]),
                        Text('Address Book'),
                        Container(
                          width: double.maxFinite,
                          height: 35,
                          // Use a Material design search bar
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              // Add a search icon or button to the search bar
                              suffixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => runFilter(value)),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: foundUsers.length,
                            itemBuilder: (context, index) => Column(children: [
                                  SizedBox(height: 10),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          recipient = foundUsers[index].id;
                                          recipientDetails =
                                              foundUsers[index].address;
                                          updateRecipient(foundUsers[index].id);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          this.widget));
                                        });
                                      },
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      '${foundUsers[index].name}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ]),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(child: Text(
                                            '${foundUsers[index].address}\n${foundUsers[index].phoneNo}')),])
                                      ])),
                                  SizedBox(height: 10)
                                ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                openNewAddressDialog();
                              },
                              child: AutoSizeText('ADD NEW ADDRESS',
                                  maxFontSize: 14,
                                  minFontSize: 11,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(200, 10),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: StadiumBorder()),
                            ),
                          ],
                        )
                      ],
                    ))),
              )));

  // Pop up addresses dialog
  Future openNewAddressDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text('Add New Address'),
                    SizedBox(height: 10),
                    Text('Name'),
                    SizedBox(
                      width: double.maxFinite,
                      height: 80,
                      child: TextField(
                        controller: newNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Text('Address'),
                    SizedBox(
                      width: double.maxFinite,
                      height: 80,
                      child: TextField(
                        controller: newAddressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Text('Phone No.'),
                    SizedBox(
                      width: double.maxFinite,
                      height: 80,
                      child: TextField(
                        controller: newPhoneNoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addAddress(
                            newNameController.text,
                            newAddressController.text,
                            newPhoneNoController.text);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    this.widget));
                      },
                      child: Text('ADD NEW ADDRESS'),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 10),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: StadiumBorder()),
                    ),
                  ],
                ))),
          ));

  Widget singleAddress(Address foundUsers) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
        SizedBox(height: 10),
        Text('${foundUsers.name}\n${foundUsers.address}\n${foundUsers.phoneNo}'),
        SizedBox(height: 10)
      ]);

  Widget singleItem(Items item) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: <Widget>[
                // Selected Image
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 140,
                    width: 90,
                    child: Image.network(widget.image, fit: BoxFit.cover),
                  ),
                ),

                // Info
                Container(
                    child: Row(
                  children: [
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Overview',
                          maxFontSize: 15,
                          minFontSize: 11,
                          maxLines: 1,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: AutoSizeText(
                                'Item From',
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              child: Text(': '),
                            ),
                            Container(
                              width: 140,
                              child: AutoSizeText(
                                widget.shipsFrom,
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: AutoSizeText(
                                'Date Stored',
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              child: Text(': '),
                            ),
                            Container(
                              child: AutoSizeText(
                                widget.dateStored,
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: AutoSizeText(
                                'Shop/Seller',
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              child: Text(': '),
                            ),
                            Container(
                              child: AutoSizeText(
                                item.seller,
                                maxFontSize: 15,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              child: AutoSizeText(
                                'Dimensions',
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              child: Text(': '),
                            ),
                            Container(
                              width: 140,
                              child: AutoSizeText(
                                '${length}cm x ${width}cm x ${height}cm',
                                maxFontSize: 15,
                                minFontSize: 11,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(height: 10),

            // Images
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 55,
                  width: 45,
                  child: Image.network(widget.image, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 5),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 55,
                  width: 45,
                  child: Image.network(image1, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 5),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 55,
                  width: 45,
                  child: Image.network(image2, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 5),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 55,
                  width: 45,
                  child: Image.network(image3, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 5),
            ]),
          ]),
        ),
      );

  // Custom Shipping Method Button
  Widget CustomShippingMethodButton(int iconName, int index) {
    return ElevatedButton(
        onPressed: () {
          if (shippingMethodString == 'both') {
            setState(() {
              selectedShipping = index;
              if (selectedShipping == 0) {
                // updateShippingPlane();
              } else if (selectedShipping == 1) {
                // updateShippingShip();
              }
            });
          } else {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //       content: Text('Shipping via $shippingMethodString only')),
            // );
          }
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(5),
            backgroundColor: (selectedShipping == index)
                ? Theme.of(context).primaryColor
                : Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Stack(
          children: [
            Center(
                child: (iconName == 0xe297)
                    ? Transform.rotate(
                        angle: 45 * math.pi / 180,
                        child: Icon(
                          IconData(iconName, fontFamily: 'MaterialIcons'),
                          color: Colors.white,
                        ))
                    : Icon(
                        IconData(iconName, fontFamily: 'MaterialIcons'),
                        color: Colors.white,
                      ))
          ],
        ));
  }
}
