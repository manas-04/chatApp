// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/authScreen.dart';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;

  bool getIsLoading() {
    return _isLoading;
  }

  void setIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void getAndSetData() async {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    notifyListeners();
  }

  void deleteUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final groups = doc.data()!['groups'] as List<dynamic>;
    final archivedGroups = doc.data()!['archivedGroups'] as List<dynamic>;

    for (var element in groups) {
      var docRef = await FirebaseFirestore.instance
          .collection('groups')
          .doc(element)
          .collection('details')
          .doc('generalDetails')
          .get();
      final members = docRef.get('noOfPeople') as int;

      if (members == 1) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(element)
            .collection('details')
            .doc('generalDetails')
            .delete();
        final instance = FirebaseFirestore.instance;
        final batch = instance.batch();
        var collection =
            instance.collection('groups').doc(element).collection("chats");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      } else {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(element)
            .collection('details')
            .doc('generalDetails')
            .update({
          "noOfPeople": members - 1,
          "groupMember": FieldValue.arrayRemove([user.uid])
        });
      }
    }

    for (var element in archivedGroups) {
      var docRef = await FirebaseFirestore.instance
          .collection('groups')
          .doc(element)
          .collection('details')
          .doc('generalDetails')
          .get();
      final members = docRef.get('noOfPeople') as int;

      if (members == 1) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(element)
            .collection('details')
            .doc('generalDetails')
            .delete();
        final instance = FirebaseFirestore.instance;
        final batch = instance.batch();
        var collection =
            instance.collection('groups').doc(element).collection("chats");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      } else {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(element)
            .collection('details')
            .doc('generalDetails')
            .update({
          "noOfPeople": members - 1,
          "groupMember": FieldValue.arrayRemove([user.uid])
        });
      }
    }
    await FirebaseFirestore.instance.collection("users").doc(user.uid).delete();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AuthScreen.routeName,
      (Route<dynamic> route) => false,
      arguments: false,
    );
    user.delete();
  }

  void updateUser({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required String userId,
    required File? pickedImage,
    required Map<String, String?> data,
  }) async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setIsLoading();
    if (isValid) {
      formKey.currentState!.save();

      if (pickedImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child(userId + '.jpg');

        await ref.putFile(pickedImage);

        final url = await ref.getDownloadURL();
        data['imageUrl'] = url;
      }
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        'bio': data['bio'],
        'gender': data['gender'],
        'username': data['userName'],
        'number': data['contactNumber'],
        "imageUrl": data['imageUrl']
      });

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "User Updated successfully");
      setIsLoading();
      notifyListeners();
    }
  }
}

class UserHelper {
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUser(User? user) {
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }
}
