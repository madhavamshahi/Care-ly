import 'package:carelyR/services/firestore.dart';
import 'package:carelyR/views/widgets/userProfileView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carelyR/views/widgets/check_in_box.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr/qr.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../registration/registrationView.dart';
import '../widgets/updates_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getFAB(int n) {
    if (n == 2) {
      return FloatingActionButton.extended(
        onPressed: () {
          inputListing(context: context);

          // Add your onPressed code here!
        },
        label: Text('Update status'),
        icon: Icon(FontAwesomeIcons.plus),
        backgroundColor: Colors.blue,
      );
    }

    return Container();
  }

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
      child: FutureBuilder<DocumentSnapshot>(
          future:
              Firestore().getProfile2(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              Map data = snapshot.data!.data() as Map;

              return Container(
                margin: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Builder(builder: ((context) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height / 6.5);
                    })),
                    QrImage(
                      data: data.toString(),
                      version: QrVersions.auto,
                      size: 280.0,
                    ),
                    SizedBox(height: 20),
                    Builder(
                      builder: ((context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterComponent(
                                        title: "Registratiuon")));
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Scan code from patient's phone to check in.",
                                    maxLines: 3,
                                    style: TextStyle(
                                      letterSpacing: 1.7,
                                      fontFamily: "QuickSand",
                                      fontSize: 20.5,
                                      color: Color(0xFF1a2228),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    ),
    SingleChildScrollView(
      child: Column(
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
          Container(margin: EdgeInsets.all(15), child: CheckInBox()),
        ],
      ),
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
        floatingActionButton: getFAB(_selectedIndex),
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

inputListing({required BuildContext context}) {
  TextEditingController phn = TextEditingController();
  TextEditingController title = TextEditingController();

  TextEditingController desc = TextEditingController();

  return Alert(
      context: context,
      title: "Add an update",
      content: Column(
        children: <Widget>[
          SizedBox(height: 20),
          TextField(
            obscureText: false,
            controller: title,
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.textHeight),
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: desc,
            obscureText: false,
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.bookMedical),
              labelText: 'Description',
            ),
          ),
          TextField(
            obscureText: false,
            controller: phn,
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.userCheck),
              labelText: 'Patient ID',
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () async {
            // Firestore _firestore = new Firestore();
            // Auth auth = Auth();
            // String? name = auth.user.currentUser!.displayName;

            // FirebaseStorageService storage = FirebaseStorageService();

            // File file = File(img!.path);
            // String downloadURL =
            //     await storage.uploadImageAndGetDownloadUrl(image: file);

            // print("heeello");

            // print(downloadURL);

            // DocumentSnapshot doc = await FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(FirebaseAuth.instance.currentUser!.uid)
            //     .get();
            // Map data = doc.data() as Map;

            // String school = data['school'];

            // await _firestore.uploadListing(
            //   ListingModel(
            //       school: school,
            //       profileIMG: auth.user.currentUser!.photoURL!,
            //       phn: phn.text,
            //       name: name!,
            //       uid: auth.user.currentUser!.uid,
            //       imgURL: downloadURL,
            //       desc: desc.text),
            // );
            // Navigator.pop(context);
          },
          child: Text(
            "Done",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}
