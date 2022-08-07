// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/widgets/changeGroupName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/groupDescription.dart';
import '../widgets/leaveGroupDialogBox.dart';
import '../widgets/memberTile.dart';
import '../widgets/reportGroupDialogBox.dart';

class GroupInfoScreen extends StatelessWidget {
  GroupInfoScreen({
    Key? key,
  }) : super(key: key);
  static const String routeName = '/groupInfoScreen';

  late String adminName;
  late int members;
  late Timestamp createdDate;
  late List<dynamic> membersList;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final String groupCode = routeArgs['groupCode'] as String;
    final String groupName = routeArgs['groupName'] as String;

    return FutureBuilder<DocumentSnapshot>(
      future: Future.value(
        FirebaseFirestore.instance
            .collection('groups')
            .doc(groupCode)
            .collection('details')
            .doc('generalDetails')
            .get(),
      ),
      builder: ((context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          adminName = snapshot.data!.get('adminUserName') as String;
          members = snapshot.data!.get('noOfPeople') as int;
          createdDate = snapshot.data!.get('createdAt') as Timestamp;
          membersList = snapshot.data!.get('groupMember') as List<dynamic>;
          return AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupDescription(
                    groupName: groupName,
                    adminName: adminName,
                    createdDate: createdDate,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      bottom: 15,
                    ),
                    child: Text(
                      'Total Members : $members',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  MemberTile(
                    membersList: membersList,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ChangeGroupNameDialogBox(
                          groupName: groupName,
                          groupCode: groupCode,
                        ),
                      );
                    },
                    child: const ListTile(
                      contentPadding: EdgeInsets.only(left: 25),
                      leading: Icon(
                        Icons.edit,
                        color: Colors.lightBlueAccent,
                      ),
                      title: Text(
                        'Change Group Name',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => LeaveGroupDialogBox(groupCode),
                      );
                    },
                    child: const ListTile(
                      contentPadding: EdgeInsets.only(left: 25),
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Exit group',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ReportGroupDialogBox(groupCode),
                      );
                    },
                    child: const ListTile(
                      contentPadding: EdgeInsets.only(left: 25),
                      leading: Icon(
                        Icons.thumb_down,
                        color: Colors.red,
                      ),
                      title: Text(
                        'Report group',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/beeLogo1500.png'),
                const Text(
                  'Sandesh',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
