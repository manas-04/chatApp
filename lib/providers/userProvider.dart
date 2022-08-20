// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class UserProvider with ChangeNotifier {
  late LocalUser currentUser;
  User? user = FirebaseAuth.instance.currentUser;

  void getAndSetData() async {
    // ignore: unused_local_variable
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    notifyListeners();
  }

  void getUser() {}
}
