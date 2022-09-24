import 'package:flutter/material.dart';

import 'views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Auth auth = Auth();

  bool loggedIn = auth.user.currentUser != null;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: loggedIn ? Home() : LoginView(),
    ),
  );

// Ideal time to initialize
}
