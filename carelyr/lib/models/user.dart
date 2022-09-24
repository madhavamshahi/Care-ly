import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/date_time_patterns.dart';

class User {
  final String name;
  final String uid;

  late Timestamp timestamp;

  final String email;

  User({required this.email, required this.name, required this.uid});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uid = json['uid'],
        timestamp = json['timeStamp'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'email': email,
        'timeStamp': Timestamp.now(),
      };
}
