// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/chatScreen.dart';

class UserGroupProvider with ChangeNotifier {
  void removeGroupMember(String groupCode, String memberId) async {
    final docRef = await UserGroupHelper().getGroupDetails(groupCode);
    final members = docRef.get('noOfPeople') as int;

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupCode)
        .collection('details')
        .doc('generalDetails')
        .update({
      "noOfPeople": members - 1,
      "groupMember": FieldValue.arrayRemove([memberId])
    });
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(memberId)
        .get();
    final groupList = doc.data()!['groups'] as List<dynamic>;
    final archiveGroup = doc.data()!['archivedGroups'] as List<dynamic>;

    if (groupList.contains(groupCode)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(memberId)
          .update({
        "groups": FieldValue.arrayRemove([groupCode])
      });
      notifyListeners();
      return;
    }

    if (archiveGroup.contains(groupCode)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(memberId)
          .update({
        "archivedGroups": FieldValue.arrayRemove([groupCode])
      });
      notifyListeners();
      return;
    }
  }

  void leaveGroup(String groupCode, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    late int members;

    final docRef = await UserGroupHelper().getGroupDetails(groupCode);

    if (docRef.exists) {
      members = docRef.get('noOfPeople') as int;
      if (members != 1) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupCode)
            .collection('details')
            .doc('generalDetails')
            .update({
          "noOfPeople": members - 1,
          "groupMember": FieldValue.arrayRemove([user!.uid])
        });
      } else if (members == 1) {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupCode)
            .collection('details')
            .doc('generalDetails')
            .delete();
        final instance = FirebaseFirestore.instance;
        final batch = instance.batch();
        var collection =
            instance.collection('groups').doc(groupCode).collection("chats");
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      final archivedGroups = doc.data()!['archivedGroups'] as List<dynamic>;

      if (archivedGroups.contains(groupCode)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'archivedGroups': FieldValue.arrayRemove([groupCode])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'groups': FieldValue.arrayRemove([groupCode])
        });
      }

      Navigator.pop(context);
      Navigator.pushReplacementNamed(
        context,
        ChatScreen.routeName,
      );
    }
  }
}

class UserGroupHelper {
  Future<DocumentSnapshot<Map<String, dynamic>>> getGroupDetails(
      String groupCode) {
    var doc = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupCode)
        .collection('details')
        .doc('generalDetails')
        .get();
    return doc;
  }
}
