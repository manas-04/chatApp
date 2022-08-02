// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chats/messages.dart';
import '../chats/newMessage.dart';
import '../components/logOutDialogBox.dart';

class GroupInbox extends StatelessWidget {
  static const String routeName = '/GroupInbox';

  const GroupInbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late int members;
    late List<dynamic> membersList;
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final String groupCode = routeArgs['groupCode'] as String;
    final String groupName = routeArgs['groupName'] as String;

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
        membersList = docRef.get('groupMember') as List<dynamic>;
        if (membersList.contains(user!.uid)) {
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupCode)
              .collection('details')
              .doc('generalDetails')
              .update({
            "noOfPeople": members - 1,
            "groupMember": FieldValue.arrayRemove([user.uid])
          });

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            "groups": FieldValue.arrayRemove([groupCode])
          });
        }
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'search') {
              } else if (value == 'leaveGroup') {
                _leaveGroup();
              } else if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (context) => const LogOutDialogBox(),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: const [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Search'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: const [
                    SizedBox(
                      width: 10,
                    ),
                    Text('Leave Group'),
                  ],
                ),
                value: 'leaveGroup',
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(groupCode),
          ),
          NewMessage(groupCode),
        ],
      ),
    );
  }
}
