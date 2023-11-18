import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final allChecked =
      CheckBoxModal(title: 'All Checked', days: '0', itemValue: '0');
  final checkBoxList = [
    CheckBoxModal(title: 'WRXW-9D7B-G6T5', days: '8', itemValue: '0.00'),
    CheckBoxModal(title: 'WRXW-9D7B-X9W1', days: '12', itemValue: '0.00'),
  ];

  List<bool> isSelected = [false, false];
  List<bool> isSelected2 = [false, false];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
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
                    image: AssetImage('assets/images/philippines_flag.png'),
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
                      image: AssetImage('assets/images/australia_flag.png'),
                    ),
                  )
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(60),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TabBar(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          unselectedLabelColor: Theme.of(context).primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).primaryColor,
                          ),
                          tabs: [
                            Tab(
                              child: Container(
                                  // move to left
                                  height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("CART"),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              body: SlidingUpPanel(
                  panel: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Air Cargo"),
                            Text(
                              "2 item/s",
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
                              "2 kgs",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Air Cargo Rate'),
                            SizedBox(width: 150),
                            Text('x'),
                            Text("AUD 8.99"),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(' '),
                            Text("AUD 17.98"),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fixed Handling Fee'),
                            Text(
                              "AUD 12.00",
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Valuation Fee'),
                            SizedBox(width: 150),
                            Text('+'),
                            Text("AUD 0.00"),
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
                            Text("AUD 29.98"),
                          ],
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Storage Fee'),
                            Text("AUD 1.26"),
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
                            Text("AUD 31.24"),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: ElevatedButton(
                                onPressed: () {
                                  openDialog();
                                },
                                child: Text('PROCEED TO CHECKOUT'),
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
                  collapsed: Container(
                    decoration: BoxDecoration(color: Colors.white),

                    // collapsed text
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Shipment Cost'),
                                  Text("AUD 31.24"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        child: ElevatedButton(
                                      onPressed: () {
                                        openDialog();
                                      },
                                      child: Text('PROCEED TO CHECKOUT'),
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
                  body: TabBarView(
                    children: [
                      ListView(
                        children: [
                          // Check All
                          ListTile(
                            onTap: () => onAllClicked(allChecked),
                            leading: Checkbox(
                              value: allChecked.value,
                              onChanged: (value) => onAllClicked(allChecked),
                            ),
                            title: Text(
                              allChecked.title,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),

                          // Individual items
                          Divider(),
                          ...checkBoxList.map(
                            (item) => Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                children: [
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
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Column(children: [
                                                // Checkbox
                                                Checkbox(
                                                  value: item.value,
                                                  onChanged: (value) =>
                                                      onItemClicked(item),
                                                ),
                                              ]),
                                              // Image
                                              Container(
                                                color: Colors.blue,
                                                height: 100,
                                                width: 60,
                                                child: Image.asset(
                                                    'assets/images/sc_logo_red.png'),
                                              ),
                                              // Info
                                              Container(
                                                width: 250,
                                                child: Column(
                                                  children: [
                                                    Text(item.title),
                                                    SizedBox(height: 10),
                                                    Row(children: [
                                                      SizedBox(width: 10),
                                                      Text(
                                                          'Days in PH storage:'),
                                                      SizedBox(width: 10),
                                                      Text(item.days)
                                                    ]),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 10),
                                                        Text('Package value:'),
                                                        SizedBox(width: 10),
                                                        Text(item.itemValue),
                                                        SizedBox(width: 10),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            debugPrint(
                                                                'Update Clicked');
                                                          },
                                                          child: Text('Update'),
                                                          style: ElevatedButton.styleFrom(
                                                              fixedSize:
                                                                  const Size(
                                                                      85, 10),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              shape:
                                                                  StadiumBorder()),
                                                        )
                                                      ],
                                                    ),
                                                    Row(children: [
                                                      SizedBox(width: 10),
                                                      Text('Shipment method:'),
                                                      // Toggle buttons
                                                      Container(
                                                          color: Colors.grey,
                                                          child: ToggleButtons(
                                                            renderBorder: false,
                                                            isSelected: isSelected,
                                                            fillColor: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            children: <Widget>[
                                                              // Plane
                                                              Container(
                                                                width: 50,
                                                                child: Image.asset(
                                                                    'assets/images/plane.png'),
                                                              ),
                                                              // Ship
                                                              Container(
                                                                width: 50,
                                                                child: Image.asset(
                                                                    'assets/images/ship.png'),
                                                              ),
                                                            ],
                                                            onPressed:
                                                            // single selection
                                                                (int newIndex) {
                                                              setState(() {
                                                                for (int index = 0; index < isSelected.length; index++) {
                                                                  if (index ==
                                                                      newIndex) {
                                                                    isSelected[
                                                                            index] =
                                                                        true;
                                                                    // add circle
                                                                  } else {
                                                                    isSelected[
                                                                            index] =
                                                                        false;
                                                                  }
                                                                }
                                                              });
                                                            },
                                                          )),
                                                    ]),
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
                          )
                        ],
                      )
                    ],
                  )))),
    );
  }

  onAllClicked(CheckBoxModal ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;
      checkBoxList.forEach((element) {
        element.value = newValue;
      });
    });
  }

  onItemClicked(CheckBoxModal ckbItem) {
    final newValue = !ckbItem.value;
    setState(() {
      ckbItem.value = newValue;

      if (!newValue) {
        allChecked.value = false;
      } else {
        final allListChecked = checkBoxList.every((element) => element.value);
        allChecked.value = allListChecked;
      }
    });
  }

// Pop up dialog
  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Container(
              height: 180,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        }, child:
                        Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.grey.shade300,
                        ),),
                      ],
                    ),
                    Text('Ships From'),
                    GestureDetector(
                        onTap: () {
                          print("Tapped a Container");
                        },
                        child: Container(
                            child: Row(children: [
                          Image(
                            image: AssetImage(
                                'assets/images/philippines_flag.png'),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 30),
                          Text('Philippines'),
                        ]))),
                    GestureDetector(
                        onTap: () {
                          print("Tapped a Container");
                        },
                        child: Container(
                            child: Row(children: [
                          Image(
                            image: AssetImage('assets/images/japan_flag.png'),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 30),
                          Text('Japan'),
                        ]))),
                    GestureDetector(
                        onTap: () {
                          print("Tapped a Container");
                        },
                        child: Container(
                            child: Row(children: [
                          Image(
                            image: AssetImage(
                                'assets/images/south_korea_flag.png'),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 30),
                          Text('South Korea'),
                        ]))),
                  ]))));
}

class CheckBoxModal {
  String title;
  String days;
  String itemValue;
  bool value;

  CheckBoxModal(
      {required this.title,
      required this.days,
      required this.itemValue,
      this.value = false});
}
