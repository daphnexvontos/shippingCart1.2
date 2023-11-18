import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/theme_helper.dart';
import '../widgets/navigation_menu.dart';

class PaymentPaypalPage extends StatefulWidget {
  const PaymentPaypalPage({
    Key? key,
    required this.checkoutArr,
  });

  final List checkoutArr;

  @override
  State<PaymentPaypalPage> createState() => _PaymentPaypalPageState();
}

class _PaymentPaypalPageState extends State<PaymentPaypalPage> {
  bool checkboxValue = false;
  final currentDate = DateTime.now();
  final db = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser!.email;

  final _formKey = GlobalKey<FormState>();
  final paypalEmailController = TextEditingController();
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
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
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
                    ),
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60),
                      child: Align(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text('PAYMENT',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))))),
                ),
                body: Container(
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Input your PayPal details'),
                        Expanded(child: Container()),
                        Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // PayPal email
                                  Text('Enter your PayPal email'),
                                  SizedBox(height: 5),
                                  Container(
                                    width: double.maxFinite,
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                    child: TextFormField(
                                        controller: paypalEmailController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          filled: true,
                                          fillColor: Colors.white,
                                        )),
                                  ),
                                  const SizedBox(height: 20.0),

                                  // PayPal button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          updateCart();
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  'assets/images/paypal_complete.png'),
                                              SizedBox(width: 10),
                                              Text(
                                                'Checkout',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(8),
                                            fixedSize: const Size(200, 40),
                                            backgroundColor: Color(0xFFfec43a),
                                            foregroundColor: Colors.white,
                                            shape: StadiumBorder()),
                                      ),
                                    ],
                                  ),
                                ])),
                        Expanded(child: Container()),
                      ]),
                ))));
  }

  updateCart() {
    // update status for each tracking no
    for (var i = 0; i < widget.checkoutArr.length; i++) {
      db
          .collection('users')
          .doc(accountNo)
          .collection('TrackingNumber')
          .doc(widget.checkoutArr[i])
          .update({
            'status': 'Pending Picking',
            'dateCheckout': currentDate,
            'isPaid': true
          })
          .then((value) => {
                print('status updated'),
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
                              Text('Payment successful!'),
                              ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationMenu()));
                        },
                        child: Text('RETURN TO HOME PAGE'),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(300, 10),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder()),
                      ),
                            ])))))
              })
          .catchError((error) => print(error));
    }
  }
}
