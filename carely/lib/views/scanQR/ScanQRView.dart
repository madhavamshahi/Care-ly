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

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
Nurse nurse = Nurse(email: "", work: "", uid: "", phn: "", name: "");

String formatted3 = "";

class ScanQRView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/illus34.png'),
                  height: 250,
                ),
                SizedBox(height: 50.0),
                GestureDetector(
                  onTap: () async {
                    if (await InternetConnectionChecker().hasConnection) {
                      String data =
                          await QrService().scanQR(); //json file as string
                      var gg = jsonEncode(data);
                      Map map = json.decode(data, reviver: (k, v) {
                        return v;
                      });

                      print(map['phn']);
                    } else {
                      showInSnackBar(
                          context: context,
                          value:
                              "No Internet connection. Please connect to the internet and then try again.",
                          color: Colors.red);
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
                    "After scanning their code, your profile will be shared to him/her while his/her profile will be shared to you.",
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
    );
  }
}

void showInSnackBar(
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
