import 'package:carely/views/registration/registrationView.dart';
import 'package:flutter/material.dart';

import 'views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carely/services/firestore.dart';
import 'views/login/login.dart';

bool? loggedIn;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Auth auth = Auth();

  loggedIn = auth.user.currentUser != null;

  if (!(!loggedIn!)) {
    //is logged in
    Firestore _fireStore = new Firestore();
    print('lodd');

    Map map = await _fireStore.getProfile(auth.user.currentUser!.uid);

    if (!(map.containsKey('phn'))) {
      runApp(MyApp2());
    } else {
      print('ssss');
      runApp(
        MyApp(),
      );
    }
  } else {
    runApp(
      MyApp(),
    );
  }
  print("dsfasdf");
// Ideal time to initialize
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: loggedIn! ? Home() : LoginView(),
    );
  }
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('heree');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterComponent(
        title: "Register",
      ),
    );
  }
}
