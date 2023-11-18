import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/addresses.dart';
import '../widgets/drawer_menu.dart';

class AddressBookPage extends StatefulWidget {
  const AddressBookPage({
    super.key,
  });

  @override
  State<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  final db = FirebaseFirestore.instance;
  // Get current user info
  final user = FirebaseAuth.instance.currentUser!;
  final email = FirebaseAuth.instance.currentUser!.email;

  final searchController = TextEditingController();
  final newNameController = TextEditingController();
  final newAddressController = TextEditingController();
  final newPhoneNoController = TextEditingController();

  var address = [Address(name: 'test', address: 'test', phoneNo: '0', id: '0')];
  var name = [];
  var addressArr = [];
  var addressId = [];
  var addressLength = 0;
  var phone = [];
  var foundUsers = [];
  var recipient;
  var recipientDetails = 'Select receiver address';
  var selectedShipping;
  var accountNo;

  @override
  void initState() {
    super.initState();
    _getAccountNo();
    foundUsers = address;
  }

  @override
  void dispose() {
    searchController.dispose();
    newNameController.dispose();
    newAddressController.dispose();
    newPhoneNoController.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
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
            getAddresses();
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future getAddresses() async {
    await db
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
      // array of orders
      for (var i = 0; i < addressLength; i++) {
        setState(() {
          address.add(Address(
              name: name[i].toString(),
              address: addressArr[i].toString(),
              phoneNo: phone[i].toString(),
              id: addressId[i].toString()));
        });
        // CheckBoxState(title: orderArr[i]['isChecked'].toString());
      }
    });
    address.removeWhere((item) => item.name == 'test');
    foundUsers = address;
  }

  Future runFilter(String enteredKeyword) async {
    var results = [
      Address(
        name: '',
        address: '',
        phoneNo: '',
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
      print(foundUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Address Book",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  elevation: 0.5,
                  iconTheme: const IconThemeData(color: Colors.white),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                          Theme.of(context).primaryColor,
                          Theme.of(context).hintColor,
                        ])),
                  ),
                ),
                endDrawer: DrawerMenu(),
                body: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          itemBuilder: (context, index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                singleAddress(foundUsers[index])
                              ]),
                        ),
                        SizedBox(height: 10),
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
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))))));
  }

  Widget singleAddress(Address foundUsers) => Column(children: [
        SizedBox(height: 10),
        foundUsers.name == 'test'
            ? Text('')
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${foundUsers.name}', style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${foundUsers.address}${foundUsers.phoneNo}'),
                ],
              ),
        SizedBox(height: 10)
      ]);

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    this.widget)).then((value) {
                          setState(() {});
                        });
                      },
                      child: AutoSizeText('ADD NEW ADDRESS',
                          maxFontSize: 14,
                          minFontSize: 11,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 10),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: StadiumBorder()),
                    ),
                  ],
                ))),
          ));
  addAddress(newName, newAddress, newPhoneNo) {
    print(accountNo);
    db
        .collection('users')
        .doc(accountNo)
        .collection('addresses')
        .add({'Name': newName, 'Address': newAddress, 'Phone No': newPhoneNo});
  }
}
