// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserGroupProvider with ChangeNotifier {
  void removeGroupMember(String groupCode, String memberId) async {
    var docRef = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupCode)
        .collection('details')
        .doc('generalDetails')
        .get();
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
}
