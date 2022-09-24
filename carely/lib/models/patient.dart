import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/date_time_patterns.dart';

class Patient {
  final String name;
  final String uid;

  final String phn;

  final String email;

  Patient({
    required this.email,
    required this.name,
    required this.uid,
    required this.phn,
  });

  Patient.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        uid = json['uid'],
        phn = json['phn'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'phn': phn,
        'email': email,
      };
}
