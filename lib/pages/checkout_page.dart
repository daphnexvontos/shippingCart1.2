import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'payment_card_page.dart';
import 'payment_paypal_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    Key? key,
    required this.checkoutArr,
    required this.shipAirArr,
    required this.chargeableWeight,
    required this.airCargoRate,
    required this.valuationFee,
    required this.totalCargoFee,
    required this.storageFee,
    // required this.shipSeaArr,
  });

  final List checkoutArr;
  final List shipAirArr;
  final chargeableWeight;
  final airCargoRate;
  final valuationFee;
  final totalCargoFee;
  final storageFee;

  // final List shipSeaArr;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<bool> isChecked = [false, false];
  bool checkboxValue = false;
  List<bool> paymentMethodBool = [false, false];
  final promoCodeController = TextEditingController();

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
              backgroundColor: Colors.transparent,
              elevation: 0,
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
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Align(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text('CHECKOUT',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold))))),
            ),

            // Sliding up panel
            body: SlidingUpPanel(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              panel: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 100,
                            height: 5,
                          ),
                        ],
                      ),

                      // Air Cargo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Air Cargo"),
                          Text(
                            '${widget.shipAirArr.length.toString()} item/s',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Text('Estimated Delivery'),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Chargeable Weight'),
                          Text(
                            widget.chargeableWeight.toStringAsFixed(2) + ' kg/s',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Air Cargo Rate'),
                          SizedBox(width: 100),
                          Text('x'),
                          Text('AUD 20.00'),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(' '),
                          Text('AUD ' + widget.airCargoRate.toStringAsFixed(2)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fixed Handling Fee'),
                          Text(
                            "AUD 0",
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Valuation Fee'),
                          SizedBox(width: 100),
                          Text('+'),
                          Text("AUD " + widget.valuationFee.toStringAsFixed(2)),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Air Cargo Fee'),
                          Text("AUD " + widget.totalCargoFee.toStringAsFixed(2)),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Sea Cargo
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Sea Cargo"),
                      //     Text(
                      //       '${widget.shipSeaArr.length.toString()} item/s',
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ],
                      // ),
                      // Text('Estimated Delivery'),
                      // SizedBox(height: 30),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Chargeable Weight'),
                      //     Text(
                      //       "0 kgs",
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(' '),
                      //     Text("AUD 0"),
                      //   ],
                      // ),
                      // SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Fixed Handling Fee'),
                      //     Text(
                      //       "AUD 0",
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text('Total Sea Cargo Fee'),
                      //     Text("AUD 0"),
                      //   ],
                      // ),

                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Storage Fee'),
                          Text("AUD " + widget.storageFee.toStringAsFixed(2)),
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipment Cost'),
                          Text("AUD " +
                              (widget.totalCargoFee + widget.storageFee)
                                  .toStringAsFixed(2)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                child: ElevatedButton(
                              onPressed: () {
                                print(checkboxValue.toString());
                                // If T&C box is checked, proceed
                                if (checkboxValue == true) {
                                  // if credit card
                                  if (paymentMethodBool.toString() ==
                                      '[true, false]') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please select payment method')));
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             PaymentCardPage(
                                    //                 checkoutArr:
                                    //                     widget.checkoutArr)));
                                  } else if (paymentMethodBool.toString() ==
                                      '[false, true]') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentPaypalPage(
                                                    checkoutArr:
                                                        widget.checkoutArr)));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please select payment method')));
                                  }
                                } else {
                                  // Show snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please check terms and conditions')));
                                }
                              },
                              child: Text('PAY AND SHIP'),
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(200, 10),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: StadiumBorder()),
                            )),
                          ]),
                    ],
                  ),
                ),
              ),

              // collapsed text
              collapsed: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: 100,
                                height: 5,
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipment Cost'),
                              Text("AUD " +
                                  (widget.totalCargoFee + widget.storageFee)
                                      .toString()),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    // if T&C box is selected, proceed
                                    if (checkboxValue == true) {
                                      if (paymentMethodBool.toString() ==
                                          '[true, false]') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Credit card option not available')));
                                        // Navigator.of(context).push(
                                        //     new MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             PaymentCardPage(
                                        //                 checkoutArr: widget
                                        //                     .checkoutArr)));
                                      } else if (paymentMethodBool.toString() ==
                                          '[false, true]') {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentPaypalPage(
                                                        checkoutArr: widget
                                                            .checkoutArr)));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Please select payment method')));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Please check terms and conditions')));
                                    }
                                  },
                                  child: Text('PAY AND SHIP'),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(200, 10),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: StadiumBorder()),
                                )),
                              ]),
                        ],
                      )),
                ),
              ),

              body: SingleChildScrollView(child: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How do you want to pay?'),
                      SizedBox(height: 10),
                      Container(
                          width: double.maxFinite,
                          height: 160,
                          child: LayoutBuilder(builder: (context, constraints) {
                            // Toggle buttons
                            return ToggleButtons(
                                constraints: BoxConstraints.expand(
                                  width: constraints.maxWidth / 2,
                                ),
                                renderBorder: false,
                                fillColor: Colors.transparent,
                                isSelected: paymentMethodBool,
                                children: <Widget>[
                                  // Credit Card
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Container(
                                                height: 160,
                                                child: Card(
                                                    color: Colors.grey.shade200,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Checkbox(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                    ),
                                                                    visualDensity:
                                                                        VisualDensity
                                                                            .compact,
                                                                    value:
                                                                        isChecked[
                                                                            0],
                                                                    onChanged:
                                                                        (value) {
                                                                      print(
                                                                          'checkbox clicked');
                                                                    }),
                                                              ]),
                                                          Text('Credit Card',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                          Container(
                                                            width: 80,
                                                            child: Image.asset(
                                                                'assets/images/credit_card.png'),
                                                          ),
                                                        ],
                                                      ),
                                                    )))),
                                      ]),

                                  // PayPal
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Container(
                                                height: 160,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Checkbox(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                value:
                                                                    isChecked[
                                                                        1],
                                                                onChanged:
                                                                    (value) {
                                                                  print(
                                                                      'checkbox clicked');
                                                                }),
                                                          ]),
                                                      Container(
                                                        width: 55,
                                                        child: Image.asset(
                                                            'assets/images/paypal_name.png'),
                                                      ),
                                                      Container(
                                                        width: 80,
                                                        child: Image.asset(
                                                            'assets/images/paypal_logo.png'),
                                                      ),
                                                    ],
                                                  ),
                                                ))),
                                      ]),
                                ],
                                onPressed:
                                    // single selection
                                    (int newIndex) {
                                  if (newIndex == 1) {
                                    setState(() {
                                      for (int index = 0;
                                          index < paymentMethodBool.length;
                                          index++) {
                                        // if(index == newIndex) if CC option is available
                                        if (index == newIndex) {
                                          paymentMethodBool[index] = true;
                                          isChecked[index] = true;
                                        } else {
                                          paymentMethodBool[index] = false;
                                          isChecked[index] = false;
                                        }
                                      }
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Credit card option not available')));
                                  }
                                });
                          })),

                      SizedBox(height: 20),

                      // Summary
                      Container(
                        // decoration: BoxDecoration(
                        //   boxShadow: [
                        //     BoxShadow(
                        //         color: Colors.grey.shade400,
                        //         spreadRadius: .1,
                        //         blurRadius: 15,
                        //         offset: const Offset(-5, 5)),
                        //   ],
                        // ),
                        child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                                padding: EdgeInsets.all(20),
                                width: double.maxFinite,
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total Air Cargo Fee'),
                                      Text("AUD " +
                                          (widget.totalCargoFee +
                                                  widget.storageFee)
                                              .toString())
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('List of Items'),
                                      Text(widget.checkoutArr.length.toString())
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Estimated Delivery'),
                                      Text('07/23/2023')
                                    ],
                                  ),
                                ]))),
                      ),
                      SizedBox(height: 20),

                      // Promo code
                      Card(
                          color: Color(0xFFFBF0A3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              width: double.maxFinite,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 180,
                                      child: AutoSizeText(
                                        'Do you have a promo code?',
                                        maxFontSize: 15,
                                        minFontSize: 10,
                                        maxLines: 1,
                                      ),
                                    ),
                                    TextButton(
                                        child: Container(
                                          width: 80,
                                          child: AutoSizeText('Enter Here',
                                              maxFontSize: 15,
                                              minFontSize: 11,
                                              maxLines: 1,
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                        onPressed: () {
                                          openPromoCodeDialog();
                                        })
                                  ],
                                ),
                              ]))),
                      SizedBox(height: 20),

                      // Terms and conditions
                      FormField<bool>(
                        builder: (state) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                      value: checkboxValue,
                                      onChanged: (value) {
                                        setState(() {
                                          checkboxValue = value!;
                                          state.didChange(value);
                                        });
                                      }),
                                  Expanded(
                                    child: Text(
                                      "Ticking the box and paying for shipment means I have read, understood, and agreed to Shipping Cart's updated Terms and Conditions",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 350),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.errorText ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        validator: (value) {
                          if (!checkboxValue) {
                            return 'You need to accept terms and conditions';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  )),) 
            ))));
  }

  Future openPromoCodeDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              height: 200,
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
                  Text(
                    'Promo Code',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          controller: promoCodeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
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
                        onPressed: () {},
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
}
