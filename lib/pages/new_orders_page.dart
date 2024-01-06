import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;
  final _formKey = GlobalKey<FormState>();
  final itemTrackingNumberController = TextEditingController();
  final itemInvoiceValueController = TextEditingController();
  final notesController = TextEditingController();
  List<bool> newOrderBool = [false, false];
  var bundle = ['For consolidation', 'Single order item'];

  var selectedBundle;
  var trackingNumbers = [];
  var usersAccountNo = [];
  var accountNo;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
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
  // void pageController(int index) {
  //   if (index == 0) {
  //     context.push('/');
  //   } else if (index == 1) {
  //     context.push('/shipments');
  //   } else if (index == 2) {
  //     context.push('/cart');
  //   } else if (index == 3) {
  //     context.push('/newOrder');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            // bottomNavigationBar: BottomNavBar(
            //   index: 3,
            //   configs: navbarConfigs,
            //   onTap: (index) {
            //     pageController(index);
            //   },
            // ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('New Orders Entry'),
              automaticallyImplyLeading: false,
            ),
            body: Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item Tracking Number
                          Text('Tracking Number'),
                          SizedBox(height: 5),
                          Container(
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: itemTrackingNumberController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter tracking number';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          )),
                          const SizedBox(height: 20.0),

                          // Item Invoice Value
                          Text('Value'),
                          SizedBox(height: 5),
                          Container(
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: itemInvoiceValueController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter item value';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          )),
                          const SizedBox(height: 20.0),

                          // Notes
                          Text('Notes/Special Instructions'),
                          SizedBox(height: 5),
                          Container(
                              // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: notesController,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )),
                          const SizedBox(height: 20.0),

                          // Buttons
                          Text('Add-ons'),
                          SpecialHandlingButton(),
                          const SizedBox(height: 10.0),
                          Text('Bundle Type'),
                          CustomShippingMethodButton(0),
                          CustomShippingMethodButton(1),
                          const SizedBox(height: 10.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      addOrder(
                                          itemTrackingNumberController.text,
                                          itemInvoiceValueController.text,
                                          notesController.text.length > 0? notesController.text: '-',
                                          newOrderBool);
                                    } catch (error) {
                                      print(error);
                                    }
                                    ;
                                  }
                                },
                                child: Text(
                                  'SUBMIT',
                                  style: TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(200, 12),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: StadiumBorder()),
                              ),
                            ],
                          )
                        ]),
                  )
                ])))));
  }

  addOrder(itemTrackingNumber, itemInvoiceValue, notes, newOrderBool) async {
    final allUsers = FirebaseFirestore.instance.collection("users");
    await allUsers.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.data()["email"] == email) {
            setState(() {
              accountNo = docSnapshot.data()['accountNo'];
              var action;
              if (newOrderBool.toString() == '[true, false]') {
                setState(() {
                  action = 'for consolidation';
                });
              } else if (newOrderBool.toString() == '[false, true]') {
                setState(() {
                  action = 'single order item';
                });
              }

              if (newOrderBool.toString() != '[false, false]') {
                usersAccountNo = [];
                trackingNumbers = [];
                // get tracking number of all users
                db.collection('users').get().then((querySnapshot) {
                  for (var docSnapshot in querySnapshot.docs) {
                    setState(() {
                      usersAccountNo.add(docSnapshot.id);
                      // trackingNumbers.add(docSnapshot.id);
                    });
                  }
                  print('users: $usersAccountNo');
                });

                // check every email
                for (var i = 0; i < usersAccountNo.length; i++) {
                  db
                      .collection('users')
                      .doc(usersAccountNo[i])
                      .collection("TrackingNumber")
                      .get()
                      .then((querySnapshot) {
                    for (var docSnapshot in querySnapshot.docs) {
                      setState(() {
                        trackingNumbers.add(docSnapshot.id);
                      });
                    }
                  });
                }
                print(trackingNumbers);
                // check if tracking number exists
                if (trackingNumbers.contains(itemTrackingNumber)) {
                  print('duplicate!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tracking number already exists')),
                  );
                } else {
                  db
                      .collection('users')
                      .doc(accountNo)
                      .collection('TrackingNumber')
                      .doc(itemTrackingNumber.toString())
                      .set({
                    'trackingNumber': itemTrackingNumber.toString(),
                    'binLocation': '---',
                    'putawayBinLocation': '---',
                    'status': 'pending receive',
                    'bundleType': action,
                    'invoiceValue': double.parse(itemInvoiceValue),
                    "notes": notes.toString(),
                    "isPaid": false,
                    "isSpecialHandling": isChecked
                  }).then((querySnapshot) {
                    itemTrackingNumberController.clear();
                    itemInvoiceValueController.clear();
                    notesController.clear();
                    newOrderBool = [false, false];

                    // Show pop up dialog
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            content: SizedBox(
                                width: double.maxFinite,
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  Text(
                                      'Shipment submitted!\nReady to be received by the warehouse'),
                                ])))));
                  });
                  // setState((){});
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Select bundle type (for consolidation or single item order)')),
                );
              }
            });
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  // Bundle Options
  Widget CustomShippingMethodButton(int index) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade100, elevation: 0),
        onPressed: () {
          setState(() {
            selectedBundle = index;
            if (selectedBundle == 0) {
              newOrderBool = [true, false];
            } else if (selectedBundle == 1) {
              newOrderBool = [false, true];
            }
          });
        },
        child: Row(
          children: [
            Checkbox(
                value: newOrderBool[index],
                onChanged: (bool? value) {
                  setState(() {
                    selectedBundle = index;
                    if (selectedBundle == 0) {
                      newOrderBool = [true, false];
                    } else if (selectedBundle == 1) {
                      newOrderBool = [false, true];
                    }
                  });
                },
                activeColor: Theme.of(context).primaryColor),
            Text(bundle[index])
          ],
        ));
  }

  // Special handling button
  Widget SpecialHandlingButton() {
    bool value = isChecked;
    return Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100, elevation: 0),
            onPressed: () {
              setState(() {
                if (value == false) {
                  isChecked = true;
                } else {
                  isChecked = false;
                }
              });
            },
            child: Row(children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Special handling'),
              ])
            ])),
        Row(
          children: [
            const SizedBox(width: 65),
            Text('(add\'l fee for special protection)')
          ],
        )
      ],
    );
  }
}
