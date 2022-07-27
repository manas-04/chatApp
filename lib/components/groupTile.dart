// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/InboxScreen.dart';

class GroupTile extends StatefulWidget {
  final String groupCode;

  const GroupTile({Key? key, required this.groupCode}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  late String groupName;
  late String adminName;
  late int members;
  late String groupCode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: Future.value(
          FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupCode)
              .collection('details')
              .doc('generalDetails')
              .get(),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            groupName = snapshot.data!.get('groupName') as String;
            adminName = snapshot.data!.get('adminUserName') as String;
            members = snapshot.data!.get('noOfPeople') as int;
            groupCode = snapshot.data!.get('groupCode') as String;
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(GroupInbox.routeName, arguments: {
                  "groupName": groupName,
                  "groupCode": groupCode,
                });
              },
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 202, 202, 202),
                  child: Icon(
                    Icons.group_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                trailing: GestureDetector(
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: groupCode));
                    Fluttertoast.showToast(
                        msg: 'Group Code copied to Clipboard');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Members : $members'),
                      Text(
                        'Group Code : $groupCode',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  groupName,
                ),
                subtitle: Text('Admin : $adminName'),
              ),
            );
          } else {
            return Container();
            // return const Padding(
            //   padding: EdgeInsets.only(top: 10),
            //   child: Center(
            // child: Padding(
            //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //   child: CircularProgressIndicator(),
            // ),
            //       ),
            // );
          }
        });
  }
}
