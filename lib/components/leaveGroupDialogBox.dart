// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/chatScreen.dart';

class LeaveGroupDialogBox extends StatelessWidget {
  final String groupCode;

  const LeaveGroupDialogBox(this.groupCode);

  @override
  Widget build(BuildContext context) {
    late int members;

    void _leaveGroup() async {
      User? user = FirebaseAuth.instance.currentUser;

      var docRef = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupCode)
          .collection('details')
          .doc('generalDetails')
          .get();

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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Are you sure, you want to \nleave this group ?',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    _leaveGroup();
                  },
                  child: const Text('Yes'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
