// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/widgets/changeGroupDialogBox.dart';
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
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String groupCode = routeArgs['groupCode'] as String;
    final String groupName = routeArgs['groupName'] as String;
    final String? groupImage = routeArgs['groupImage'] as String?;
    final String adminName = routeArgs['adminName'] as String;
    final int members = routeArgs['members'] as int;
    final Timestamp createdDate = routeArgs['createdDate'] as Timestamp;
    final List<dynamic> membersList = routeArgs['membersList'] as List<dynamic>;
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupDescription(
              groupCode: groupCode,
              groupName: groupName,
              adminName: adminName,
              createdDate: createdDate,
              groupImage: groupImage,
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
                  builder: (context) => ChangeGroupImageDialog(
                    groupCode: groupCode,
                  ),
                );
              },
              child: const ListTile(
                contentPadding: EdgeInsets.only(left: 25),
                leading: Icon(
                  Icons.groups_rounded,
                  color: Colors.lightBlueAccent,
                ),
                title: Text(
                  'Change Group Image',
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
}
