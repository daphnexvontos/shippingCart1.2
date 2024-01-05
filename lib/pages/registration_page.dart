import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import '../authentication/services/database_service.dart';
import '../common/theme_helper.dart';
import 'dart:math';
import 'login_page.dart';
import '../widgets/header_widget.dart';
import '../widgets/navigation_menu.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final postcodeController = TextEditingController();
  final passwordController = TextEditingController();
  late String accountNoTest;
  late String accountNo;
  late int randomNumber;
  var stateCode = 'NSW';

  // Initial Selected Value
  String stateDropdownValue = 'New South Wales (NSW)';
  String cityDropdownValue = 'Albury-Wodonga';

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
    stateDropdown();
  }

  Future<void> stateDropdown() async {
    print(stateDropdownValue);
  }

  // sign user up
  Future<void> signUserUp() async {
    // generate acct no
    generateRandomNum() {
      Random random = new Random();
      randomNumber = random.nextInt(10000);
      accountNoTest = 'U-${randomNumber.toString().padLeft(4, '0')}';
      print(accountNoTest);
    }

    generateRandomNum();

    // check if acct no exists
    await db.collection('users').get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        // if duplicate, run signUserUp again
        if (docSnapshot.data()["accountNo"] == accountNoTest) {
          signUserUp();
        } else {
          print('true');
          setState(() {
            accountNo = accountNoTest;
          });
        }
        // print(accountNo);
      }
    });

    try {
      // create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // add user data
      await DatabaseService().addUser(
        accountNo: accountNo,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phoneNo: mobileController.text,
        address1: addressLine1Controller.text,
        city: cityDropdownValue,
        state: stateCode,
        postal: postcodeController.text,
        country: "AU",
        password: passwordController.text,
      );

      // navigate to landing page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavigationMenu()),
      );
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

// error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        // First name
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'First Name', 'Enter your first name'),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Last name
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Last Name', 'Enter your last name'),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Email field
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: emailController,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              // ignore: prefer_is_not_empty
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Mobile number
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: mobileController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              // ignore: prefer_is_not_empty
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Address field 1
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: addressLine1Controller,
                            decoration: ThemeHelper().textInputDecoration(
                                'Unit No. | House No. | Street | Suburb'),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // State
                        Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: DropdownButton(
                                  underline: Container(
                                    color: Colors
                                        .white, // Set the underline color here
                                  ),
                                  value: stateDropdownValue,
                                  style: TextStyle(
                                    color:
                                        Colors.red, // Set the text color here
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
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      stateDropdownValue = newValue!;
                                      if (newValue == 'New South Wales (NSW)') {
                                        stateCode = 'NSW';
                                        cityDropdownValue = "Albury-Wodonga";
                                      } else if (newValue == 'Victoria (VIC)') {
                                        stateCode = 'VIC';
                                        cityDropdownValue = "Albury-Wodonga";
                                      } else if (newValue ==
                                          'Queensland (QLD)') {
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

                        // City
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: stateDropdownValue ==
                                        "New South Wales (NSW)"
                                    ? DropdownButton(
                                        value: cityDropdownValue,
                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
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
                                            items:
                                                qldCities.map((String items) {
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
                                                items: saCities
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
                                                    "Tasmania (TAS)"
                                                ? DropdownButton(
                                                    value: cityDropdownValue,
                                                    // Down Arrow Icon
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
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
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        cityDropdownValue =
                                                            newValue!;
                                                      });
                                                    },
                                                  )
                                                : stateDropdownValue ==
                                                        "Victoria (VIC)"
                                                    ? DropdownButton(
                                                        value:
                                                            cityDropdownValue,
                                                        // Down Arrow Icon
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        // Array list of items
                                                        items: vicCities.map(
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
                                                                "Australian Capital Territory (ACT)"
                                                            ? DropdownButton(
                                                                value:
                                                                    cityDropdownValue,
                                                                // Down Arrow Icon
                                                                icon: const Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down),
                                                                // Array list of items
                                                                items: actCities
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
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
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
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                          () {
                                                                        cityDropdownValue =
                                                                            newValue!;
                                                                      });
                                                                    },
                                                                  ))),
                        const SizedBox(height: 20.0),

                        // Post Code
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: postcodeController,
                            decoration:
                                ThemeHelper().textInputDecoration('Post Code'),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Password field
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),

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
                                    const Text(
                                      "I accept all terms and conditions.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
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
                        const SizedBox(height: 20.0),

                        // Register button
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: signUserUp,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        const Text(
                          "Or create account using social media",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.googlePlus,
                                size: 35,
                                color: HexColor("#EC2D2F"),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Google Plus",
                                          "You tap on GooglePlus social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: HexColor("#40ABF0")),
                                  color: HexColor("#40ABF0"),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter,
                                  size: 23,
                                  color: HexColor("#FFFFFF"),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Twitter",
                                          "You tap on Twitter social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 35,
                                color: HexColor("#3E529C"),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Facebook",
                                          "You tap on Facebook social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //child: Text('Already have an account? Login'),
                                Text.rich(TextSpan(children: [
                                  const TextSpan(
                                      text: "Already have an account? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).hintColor),
                                  ),
                                ])),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
