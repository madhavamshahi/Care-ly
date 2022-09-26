import 'package:carely/services/firestore.dart';
import 'package:carely/views/widgets/check_in_box.dart';
import 'package:carely/views/widgets/userProfileView.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:carely/services/qr_service.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'package:carely/models/nurse.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../widgets/updates_tile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

showInSnackBar(
    {required String value,
    required Color color,
    int sec = 3,
    required BuildContext context}) {
  FocusScope.of(context).requestFocus(new FocusNode());
  _scaffoldKey.currentState?.removeCurrentSnackBar();
  _scaffoldKey.currentState!.showSnackBar(new SnackBar(
    content: new Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansSemiBold"),
    ),
    backgroundColor: color,
    duration: Duration(seconds: sec),
  ));

  return Container();
}

openLoadingDialog(BuildContext context, String text) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            content: Row(children: <Widget>[
              CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation(Colors.black)),
              Expanded(
                child: Text(text),
              ),
            ]),
          ));
}

class _HomeState extends State<Home> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();
  bool isOpened = false;

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/images/qr.png'),
                height: 250,
              ),
              SizedBox(height: 50.0),
              GestureDetector(
                onTap: () async {
                  if (await InternetConnectionChecker().hasConnection) {
                    String data = await QrService().scanQR();
                    //json file as string
                    Firestore _firestore = Firestore();

                    Map<String, dynamic> map =
                        await _firestore.getProfile(data);
                    print(map['phn']);
                    await _firestore.addCheckIn1(
                        nurse: Nurse.fromJson(map),
                        uid: FirebaseAuth.instance.currentUser!.uid);
                  } else {
                    Builder(
                      builder: (context) => showInSnackBar(
                          context: context,
                          value:
                              "No Internet connection. Please connect to the internet and then try again.",
                          color: Colors.red),
                    );
                  }
                },
                child: Container(
                  // padding: EdgeInsets.all(20.0),
                  height: 60,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF1a2228),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Scan Code",
                          style: TextStyle(
                            letterSpacing: 1.7,
                            fontFamily: "QuickSand",
                            fontSize: 17.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          LineAwesomeIcons.retro_camera,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Scan the barcode to see who's looking after you ❤️",
                  style: TextStyle(
                    letterSpacing: 1.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "QuickSand",
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    Column(
      children: [
        SizedBox(
          height: 60,
        ),
        Text(
          'Check-ins',
          style: GoogleFonts.josefinSans(
            textStyle: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('checkin')
                  .where('uids', arrayContainsAny: [
                FirebaseAuth.instance.currentUser!.uid,
              ]).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, int n) {
                        return Container(
                            margin: EdgeInsets.all(15), child: CheckInBox());
                      });
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ],
    ),
    SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Text(
            'Status Updates',
            style: GoogleFonts.josefinSans(
              textStyle: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: UpdatesBoxes(),
          ),
        ],
      ),
    ),
    UserProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _endSideMenuKey,
      type: SideMenuType.slide,
      menu: Padding(
        padding: EdgeInsets.only(left: 25.0),
        child: buildMenu(),
      ),
      onChange: (_isOpened) {
        setState(() => isOpened = _isOpened);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _widgetOptions.elementAt(_selectedIndex),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.userAstronaut,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            SizedBox(
              width: 20,
            )
          ],
          leading: GestureDetector(
            onTap: () {
              toggleMenu(true);
            },
            child: Icon(
              FontAwesomeIcons.bars,
              color: Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.orange,
                hoverColor: Colors.orange,
                gap: 8,
                activeColor: Colors.blueAccent,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: FontAwesomeIcons.house,
                    text: 'Home',
                    iconColor: Colors.orange,
                  ),
                  GButton(
                    icon: FontAwesomeIcons.heart,
                    iconColor: Colors.orange,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: FontAwesomeIcons.searchengin,
                    iconColor: Colors.orange,
                    text: 'Search',
                  ),
                  GButton(
                    icon: FontAwesomeIcons.user,
                    iconColor: Colors.orange,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildMenu() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 50.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22.0,
              ),
              SizedBox(height: 16.0),
              Text(
                "Hello, John Doe",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
          title: const Text("Home"),
          textColor: Colors.white,
          dense: true,
        ),
        ListTile(
          onTap: () {},
          leading:
              const Icon(Icons.verified_user, size: 20.0, color: Colors.white),
          title: const Text("Profile"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.monetization_on,
              size: 20.0, color: Colors.white),
          title: const Text("Wallet"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading:
              const Icon(Icons.shopping_cart, size: 20.0, color: Colors.white),
          title: const Text("Cart"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading:
              const Icon(Icons.star_border, size: 20.0, color: Colors.white),
          title: const Text("Favorites"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.settings, size: 20.0, color: Colors.white),
          title: const Text("Settings"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}
