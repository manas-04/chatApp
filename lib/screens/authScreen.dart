// ignore_for_file: file_names, use_key_in_widget_constructors
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../auth/authForm.dart';
import '../screens/chatScreen.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/AuthScreen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    File? userImage,
    bool isLogin,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        await _auth
            .signInWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then((value) => null)
            .catchError((error) {
          Fluttertoast.showToast(msg: error!.message);
        });
      } else {
        await _auth
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) async {
          final ref = FirebaseStorage.instance
              .ref()
              .child('userImages')
              .child(value.user!.uid + '.jpg');

          await ref.putFile(userImage!);

          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(value.user!.uid)
              .set({
            "email": email,
            "userName": username,
            "imageUrl": userImage,
            "bio": '',
            "number": '',
            "gender": '',
            "groups": [],
            "archivedGroups": [],
          }).then((value) {
            Fluttertoast.showToast(msg: 'User created successfully !!');
          }).catchError((error) {
            // ignore: avoid_print
            print(error);
          });
        }).catchError((error) {
          Fluttertoast.showToast(msg: error!.message);
        });
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as bool;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ChatScreen();
        } else {
          return Scaffold(
            // ignore: prefer_const_constructors
            body: SingleChildScrollView(
              child: AuthForm(_submitAuthForm, _isLoading, routeArgs),
            ),
          );
        }
      },
    );
  }
}
