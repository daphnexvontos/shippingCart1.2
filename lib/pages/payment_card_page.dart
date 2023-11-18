import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/theme_helper.dart';

class PaymentCardPage extends StatefulWidget {
  const PaymentCardPage({
    Key? key,
    required this.checkoutArr,
  });

  final List checkoutArr;

  @override
  State<PaymentCardPage> createState() => _PaymentCardPageState();
}

class _PaymentCardPageState extends State<PaymentCardPage> {
  bool checkboxValue = false;
  final currentDate = DateTime.now();
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;

  final _formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cardCodeController = TextEditingController();
  final cardNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  context.pop();
                }, // Image tapped
                child: Image(
                  image: AssetImage('assets/images/back_arrow.png'),
                  height: 24,
                  width: 24,
                  // color: Colors.red,
                ),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Align(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text('PAYMENT', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))))),
            ),
            body: Container(
              margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Input your card details'),
                    SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(children: [Row(
                      children: [
                        Image(
                          width: 25,
                          image:
                              AssetImage('assets/images/credit_card_black.png'),
                        ),
                        SizedBox(width: 5),
                        Text('Add a credit or debit card'),
                      ],
                    ),
                    Row(
                      children: [
                        Image(
                          width: 25,
                          image: AssetImage('assets/images/visa_logo.png'),
                        ),
                        SizedBox(width: 3),
                        Image(
                          width: 25,
                          image:
                              AssetImage('assets/images/mastercard_logo.png'),
                        ),
                        SizedBox(width: 3),
                        Image(
                          width: 25,
                          image: AssetImage(
                              'assets/images/american_express_logo.png'),
                        ),
                        SizedBox(width: 3),
                        Image(
                          width: 25,
                          image: AssetImage('assets/images/union_pay_logo.png'),
                        ),
                        SizedBox(width: 3),
                        Image(
                          width: 25,
                          image: AssetImage('assets/images/jcb_logo.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card number
                              Text('Card number'),
                              SizedBox(height: 5),
                              Container(
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                            controller: cardNumberController,
                                            decoration: InputDecoration(
                                              labelText: '1234 5678 9012 3456',
                                              suffixIcon: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        end: 12),
                                                child: Image(
                                                    width: 8,
                                                    image: AssetImage(
                                                        'assets/images/credit_card_grey.png')),
                                              ),
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              filled: true,
                                              fillColor: Colors.white,
                                            )),
                                      )
                                    ],
                                  )),
                              const SizedBox(height: 20.0),

                              // Expiry and 3 digit code
                              Container(
                                child: Row(children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Expiry date'),
                                        SizedBox(height: 3),
                                        Container(
                                          decoration: ThemeHelper()
                                              .inputBoxDecorationShaddow(),
                                          child: TextFormField(
                                              controller: expiryDateController,
                                              decoration: InputDecoration(
                                                labelText: 'MM/YY',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                                filled: true,
                                                fillColor: Colors.white,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('CVC / CVV'),
                                        SizedBox(height: 3),
                                        Container(
                                          decoration: ThemeHelper()
                                              .inputBoxDecorationShaddow(),
                                          child: TextFormField(
                                              controller: cardCodeController,
                                              decoration: InputDecoration(
                                                labelText: '3 digits',
                                                suffixIcon: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .only(end: 12),
                                                  child: Image(
                                                      width: 8,
                                                      image: AssetImage(
                                                          'assets/images/credit_card_code.png')),
                                                ),
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                                filled: true,
                                                fillColor: Colors.white,
                                              )),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                              const SizedBox(height: 20.0),

                              // Name on card
                              Text('Name on card'),
                              SizedBox(height: 3),
                              Container(
                                width: double.maxFinite,
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                    controller: cardNameController,
                                    decoration: InputDecoration(
                                      labelText: 'J.Smith',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    )),
                              ),
                              const SizedBox(height: 20.0),

                              // Save payment details checkbox
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                      value: checkboxValue,
                                      onChanged: (value) {
                                        setState(() {
                                          checkboxValue = value!;
                                        });
                                      }),
                                  const Text(
                                    "Save for my next payment",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),

                              // Pay button
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [ 
                                  ElevatedButton(
                                    onPressed: () {
                                      updateCart();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.lock, size: 20),
                                        SizedBox(width: 5),
                                        Text('Pay')
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(50),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: StadiumBorder()),
                                  ), 
                                ],)],))
                            ]))
                  ]),
            )));
  }
  updateCart() {
    // update status for each tracking no
    for(var i = 0; i < widget.checkoutArr.length; i++)
    {
      db
        .collection('users')
        .doc(email)
        .collection('TrackingNumber')
        .doc(widget.checkoutArr[i])
        .update({'status': 'Pending Picking', 'dateCheckout': currentDate, 'isPaid': true})
        .then((value) => {print('status updated')})
        .catchError((error) => print(error));
      }
  }
}
