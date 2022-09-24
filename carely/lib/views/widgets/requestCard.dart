import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import '../constant.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RequestCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  final List phones;
  final Color bgColor;

  RequestCard(
      {required this.title,
      required this.time,
      required this.phones,
      required this.description,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          subtitle: Column(
            children: [
              Text(
                description,
                style: TextStyle(
                  color: kTitleTextColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  phones.shuffle();

                  String _url = 'tel:${phones[0]}';
                  print(_url);
                  await canLaunch(_url)
                      ? await launch(_url)
                      : Fluttertoast.showToast(
                          msg: "Couldn't launch the dialer.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 5.0,
                        ),
                      ],
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Call an officer",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "QuickSand",
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
