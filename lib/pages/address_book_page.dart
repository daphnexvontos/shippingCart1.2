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
  final emailController = TextEditingController();
  final postalController = TextEditingController();
  var stateCode = 'NSW';
  String stateDropdownValue = 'New South Wales (NSW)';
  String cityDropdownValue = 'Albury-Wodonga';

  var address = [Address(name: 'test', address: 'test', phoneNo: '0', city: 'test', state: 'test', postal: 'test', id: '0')];
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
  var city = [];
  var state = [];
  var postal = [];

  // List of items in our dropdown menu
  var items = [
    'New South Wales (NSW)',
    'Victoria (VIC)',
    'Queensland (QLD)',
    'South Australia (SA)',
    'Western Australia (WA)',
    'Tasmania (TAS)',
    'Australian Capital Territory (ACT)',
    'Northern Territory (NT)'
  ];

  var nswCities = [
    "Albury-Wodonga",
    "Armidale",
    "Ballina",
    "Balranald",
    "Batemans Bay",
    "Bathurst",
    "Bega",
    "Bourke",
    "Bowral",
    "Broken Hill",
    "Byron Bay",
    "Camden",
    "Campbelltown",
    "Cobar",
    "Coffs Harbour",
    "Cooma",
    "Coonabarabran",
    "Coonamble",
    "Cootamundra",
    "Corowa",
    "Cowra",
    "Deniliquin",
    "Dubbo",
    "Forbes",
    "Forster",
    "Glen Innes",
    "Gosford",
    "Goulburn",
    "Grafton",
    "Griffith",
    "Gundagai",
    "Gunnedah",
    "Hay",
    "Inverell",
    "Junee",
    "Katoomba",
    "Kempsey",
    "Kiama",
    "Kurri Kurri",
    "Lake Cargelligo",
    "Lismore",
    "Lithgow",
    "Maitland",
    "Moree",
    "Moruya",
    "Murwillumbah",
    "Muswellbrook",
    "Nambucca Heads",
    "Narrabri",
    "Narrandera",
    "Newcastle",
    "Nowra-Bomaderry",
    "Orange",
    "Parkes",
    "Parramatta",
    "Penrith",
    "Port Macquarie",
    "Queanbeyan",
    "Raymond Terrace",
    "Richmond",
    "Scone",
    "Singleton",
    "Sydney",
    "Tamworth",
    "Taree",
    "Temora",
    "Tenterfield",
    "Tumut",
    "Ulladulla",
    "Wagga Wagga",
    "Wauchope",
    "Wellington",
    "West Wyalong",
    "Windsor",
    "Wollongong",
    "Wyong",
    "Yass",
    "Young"
  ];

  var vicCities = [
    'Albury-Wodonga',
    "Ararat",
    "Bacchus Marsh",
    "Bairnsdale",
    "Ballarat",
    "Beechworth",
    "Benalla",
    "Bendigo",
    "Castlemaine",
    "Colac",
    "Echuca",
    "Geelong",
    "Hamilton",
    "Healesville",
    "Horsham",
    "Kerang",
    "Kyabram",
    "Kyneton",
    "Lakes Entrance",
    "Maryborough",
    "Melbourne",
    "Mildura",
    "Moe",
    "Morwell",
    "Port Fairy",
    "Portland",
    "Sale",
    "Sea Lake",
    "Seymour",
    "Shepparton",
    "Sunbury",
    "Swan Hill",
    "Traralgon",
    "Yarrawonga",
    "Wangaratta",
    "Warragul",
    "Werribee",
    "Wonthaggi"
  ];

  var qldCities = [
    "Ayr",
    "Beaudesert",
    "Blackwater",
    "Bowen",
    "Brisbane",
    "Buderim",
    "Bundaberg",
    "Caboolture",
    "Cairns",
    "Charleville",
    "Charters Towers",
    "Cooktown",
    "Dalby",
    "Deception Bay",
    "Emerald",
    "Gatton",
    "Gladstone",
    "Gold Coast",
    "Goondiwindi",
    "Gympie",
    "Hervey Bay",
    "Ingham",
    "Innisfail",
    "Kingaroy",
    "Mackay",
    "Mareeba",
    "Maroochydore",
    "Maryborough",
    "Moonie",
    "Moranbah",
    "Mount Isa",
    "Mount Morgan",
    "Moura",
    "Redcliffe",
    "Rockhampton",
    "Roma",
    "Stanthorpe",
    "Toowoomba",
    "Townsville",
    "Warwick",
    "Weipa",
    "Winton",
    "Yeppoon"
  ];

  var saCities = [
    "Adelaide",
    "Ceduna",
    "Clare",
    "Coober Pedy",
    "Gawler",
    "Goolwa",
    "Iron Knob",
    "Leigh Creek",
    "Loxton",
    "Millicent",
    "Mount Gambier",
    "Murray Bridge",
    "Naracoorte",
    "Oodnadatta",
    "Port Adelaide Enfield",
    "Port Augusta",
    "Port Lincoln",
    "Port Pirie",
    "Renmark",
    "Victor Harbor",
    "Whyalla"
  ];

  var waCities = [
    "Broome",
    "Bunbury",
    "Busselton",
    "Coolgardie",
    "Dampier",
    "Derby",
    "Fremantle",
    "Geraldton",
    "Kalgoorlie",
    "Kambalda",
    "Katanning",
    "Kwinana",
    "Mandurah",
    "Meekatharra",
    "Mount Barker",
    "Narrogin",
    "Newman",
    "Northam",
    "Perth",
    "Port Hedland",
    "Tom Price",
    "Wyndham"
  ];

  var tasCities = [
    "Beaconsfield",
    "Bell Bay",
    "Burnie",
    "Devonport",
    "Hobart",
    "Kingston",
    "Launceston",
    "New Norfolk",
    "Queenstown",
    "Richmond",
    "Rosebery",
    "Smithton",
    "Stanley",
    "Ulverstone",
    "Wynyard"
  ];

  var actCities = ["Canberra"];

  var ntCities = [
    "Alice Springs",
    "Anthony Lagoon",
    "Darwin",
    "Katherine",
    "Tennant Creek"
  ];

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
          city.add(docSnapshot.data()['city']);
          postal.add(docSnapshot.data()['postal']);
          state.add(docSnapshot.data()['state']);
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
              city: city[i].toString(),
              postal: postal[i].toString(),
              state: state[i].toString(),
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
        city: '',
        state: '',
        postal: '',
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
                    '${foundUsers.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${foundUsers.address} ${foundUsers.city}, ${foundUsers.state}'),
                  Text('${foundUsers.phoneNo}')
                ],
              ),
        SizedBox(height: 10)
      ]);

  // Pop up addresses dialog
  Future openNewAddressDialog() => showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                    // NAME
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
                    // ADDRESS
                    Text('Unit No | Street Name | Suburb'),
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
                    // STATE
                    Text('State'),
                    Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: DropdownButton(
                              underline: Container(
                                color: Colors
                                    .white, // Set the underline color here
                              ),
                              value: stateDropdownValue,
                              style: TextStyle(
                                color: Colors.red, // Set the text color here
                                fontSize: 16,
                              ),
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Container(
                                    color: Colors.white,
                                    child: Text(items),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  stateDropdownValue = newValue!;
                                  print(stateDropdownValue);
                                  if (newValue == 'New South Wales (NSW)') {
                                    stateCode = 'NSW';
                                    cityDropdownValue = "Albury-Wodonga";
                                  } else if (newValue == 'Victoria (VIC)') {
                                    stateCode = 'VIC';
                                    cityDropdownValue = "Albury-Wodonga";
                                  } else if (newValue == 'Queensland (QLD)') {
                                    stateCode = 'QLD';
                                    cityDropdownValue = "Ayr";
                                  } else if (newValue ==
                                      'South Australia (SA)') {
                                    stateCode = 'SA';
                                    cityDropdownValue = "Adelaide";
                                  } else if (newValue ==
                                      'Western Australia (WA)') {
                                    stateCode = 'WA';
                                    cityDropdownValue = "Broome";
                                  } else if (newValue == 'Tasmania (TAS)') {
                                    stateCode = 'TAS';
                                    cityDropdownValue = "Beaconsfield";
                                  } else if (newValue ==
                                      'Australian Capital Territory (ACT)') {
                                    stateCode = 'ACT';
                                    cityDropdownValue = "Canberra";
                                  } else {
                                    stateCode == 'NT';
                                    cityDropdownValue = "Alice Springs";
                                  }
                                });
                              },
                            ))),
                    const SizedBox(height: 20.0),
                    // CITY
                    Text('City'),
                    Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: stateDropdownValue == "New South Wales (NSW)"
                                ? DropdownButton(
                                    underline: Container(
                                      color: Colors
                                          .white, // Set the underline color here
                                    ),
                                    value: cityDropdownValue,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: nswCities.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        cityDropdownValue = newValue!;
                                      });
                                    },
                                  )
                                : stateDropdownValue == "Queensland (QLD)"
                                    ? DropdownButton(
                                        value: cityDropdownValue,
                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        // Array list of items
                                        items: qldCities.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            cityDropdownValue = newValue!;
                                          });
                                        },
                                      )
                                    : stateDropdownValue ==
                                            "South Australia (SA)"
                                        ? DropdownButton(
                                            value: cityDropdownValue,

                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            // Array list of items
                                            items: saCities.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                cityDropdownValue = newValue!;
                                              });
                                            },
                                          )
                                        : stateDropdownValue == "Tasmania (TAS)"
                                            ? DropdownButton(
                                                value: cityDropdownValue,
                                                // Down Arrow Icon
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                // Array list of items
                                                items: tasCities
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                // After selecting the desired option,it will
                                                // change button value to selected value
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    cityDropdownValue =
                                                        newValue!;
                                                  });
                                                },
                                              )
                                            : stateDropdownValue ==
                                                    "Victoria (VIC)"
                                                ? DropdownButton(
                                                    value: cityDropdownValue,
                                                    // Down Arrow Icon
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    // Array list of items
                                                    items: vicCities
                                                        .map((String items) {
                                                      return DropdownMenuItem(
                                                        value: items,
                                                        child: Text(items),
                                                      );
                                                    }).toList(),
                                                    // After selecting the desired option,it will
                                                    // change button value to selected value
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        cityDropdownValue =
                                                            newValue!;
                                                      });
                                                    },
                                                  )
                                                : stateDropdownValue ==
                                                        "Western Australia (WA)"
                                                    ? DropdownButton(
                                                        value:
                                                            cityDropdownValue,
                                                        // Down Arrow Icon
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        // Array list of items
                                                        items: waCities.map(
                                                            (String items) {
                                                          return DropdownMenuItem(
                                                            value: items,
                                                            child: Text(items),
                                                          );
                                                        }).toList(),
                                                        // After selecting the desired option,it will
                                                        // change button value to selected value
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            cityDropdownValue =
                                                                newValue!;
                                                          });
                                                        },
                                                      )
                                                    : stateDropdownValue ==
                                                            "Australian Capital Territory (ACT)"
                                                        ? DropdownButton(
                                                            value:
                                                                cityDropdownValue,
                                                            // Down Arrow Icon
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                            // Array list of items
                                                            items: actCities
                                                                .map((String
                                                                    items) {
                                                              return DropdownMenuItem(
                                                                value: items,
                                                                child:
                                                                    Text(items),
                                                              );
                                                            }).toList(),
                                                            // After selecting the desired option,it will
                                                            // change button value to selected value
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                cityDropdownValue =
                                                                    newValue!;
                                                              });
                                                            },
                                                          )
                                                        : stateDropdownValue ==
                                                                "Northern Territory (NT)"
                                                            ? DropdownButton(
                                                                value:
                                                                    cityDropdownValue,
                                                                // Down Arrow Icon
                                                                icon: const Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down),
                                                                // Array list of items
                                                                items: ntCities
                                                                    .map((String
                                                                        items) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        items,
                                                                    child: Text(
                                                                        items),
                                                                  );
                                                                }).toList(),
                                                                // After selecting the desired option,it will
                                                                // change button value to selected value
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    cityDropdownValue =
                                                                        newValue!;
                                                                  });
                                                                },
                                                              )
                                                            : DropdownButton(
                                                                value:
                                                                    cityDropdownValue,

                                                                // Down Arrow Icon
                                                                icon: const Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down),
                                                                // Array list of items
                                                                items: ntCities
                                                                    .map((String
                                                                        items) {
                                                                  return DropdownMenuItem(
                                                                    value:
                                                                        items,
                                                                    child: Text(
                                                                        items),
                                                                  );
                                                                }).toList(),
                                                                // After selecting the desired option,it will
                                                                // change button value to selected value
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setState(() {
                                                                    cityDropdownValue =
                                                                        newValue!;
                                                                  });
                                                                },
                                                              ))),
                    const SizedBox(height: 20.0),
                    // POST CODE
                    Text('Post Code'),
                    SizedBox(
                      width: double.maxFinite,
                      height: 80,
                      child: TextField(
                        controller: postalController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // PHONE NO
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
                    // EMAIL
                    Text('Email'),
                    SizedBox(
                      width: double.maxFinite,
                      height: 80,
                      child: TextField(
                        controller: emailController,
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
          );
        });
      });

  addAddress(newName, newAddress, newPhoneNo) {
    print(accountNo);
    db.collection('users').doc(accountNo).collection('addresses').add({
      'Name': newName,
      'Address': newAddress,
      'Phone No': newPhoneNo,
      'city': cityDropdownValue,
      'country': 'AU',
      'email': emailController.text,
      'postal': postalController.text,
      'state': stateCode
    });
  }
}
