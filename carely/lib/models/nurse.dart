import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/date_time_patterns.dart';

class Nurse {
  final String name;
  final String uid;

  final String phn;

  final String work;
  final String email;

  Nurse(
      {required this.email,
      required this.name,
      required this.uid,
      required this.phn,
      required this.work});

  Nurse.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uid = json['uid'],
        phn = json['phn'],
        work = json['work'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'phn': phn,
        'work': work,
        'email': email,
      };
}
