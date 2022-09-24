import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInBox extends StatelessWidget {
  CheckInBox({Key? key}) : super(key: key);
  List colors = [
    Color(0xFFffdf00),
    Color(0xFFfff44f),
    Color(0xFFffae42),
    Color(0xFFfdde6c),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFFF9D276),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              //offset: Offset(0, 4),
              color: Color(0xFFF9D276), //edited
              spreadRadius: 4,
              blurRadius: 10 //edited
              )
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amanda, Nurse',
                    style: GoogleFonts.josefinSans(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Text(
                      "For doing the regular checkup of the patient xyz yada yada hello world python java c++",
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.josefinSans(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "September 25, 2022 at 4:10 PM",
                      style: GoogleFonts.josefinSans(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
