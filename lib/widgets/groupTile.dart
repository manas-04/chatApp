// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/groupImageDialog.dart';
import '../constants.dart';
import '../screens/InboxScreen.dart';

class GroupTile extends StatefulWidget {
  final String groupCode;
  final bool archive;

  const GroupTile({Key? key, required this.groupCode, required this.archive})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  late String groupName;
  late String adminName;
  late int members;
  late String? groupImage;
  late Timestamp createdDate;
  late List<dynamic> membersList;

  void _dismiss(String groupCode, bool archive) async {
    User? user = FirebaseAuth.instance.currentUser;

    archive
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
            "archivedGroups": FieldValue.arrayRemove([groupCode])
          })
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
            "groups": FieldValue.arrayRemove([groupCode])
          });
    archive
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
            "groups": FieldValue.arrayUnion([groupCode])
          })
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
            "archivedGroups": FieldValue.arrayUnion([groupCode])
          });
  }

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
            groupImage = snapshot.data!.get('groupImage') as String?;
            createdDate = snapshot.data!.get('createdAt') as Timestamp;
            membersList = snapshot.data!.get('groupMember') as List<dynamic>;

            return Dismissible(
              key: ValueKey(widget.groupCode),
              background: Container(
                color: kPrimaryColor.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        widget.archive
                            ? Icons.unarchive_outlined
                            : Icons.archive_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                _dismiss(widget.groupCode, widget.archive);
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(GroupInbox.routeName, arguments: {
                    "groupName": groupName,
                    "groupCode": widget.groupCode,
                    "groupImage": groupImage,
                    "adminName": adminName,
                    "members": members,
                    "createdDate": createdDate,
                    "membersList": membersList,
                  });
                },
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => GroupImageDialog(
                          groupName: groupName,
                          groupCode: widget.groupCode,
                          groupImage: groupImage,
                          adminName: adminName,
                          createdDate: createdDate,
                          members: members,
                          membersList: membersList,
                          showinfo: true,
                        ),
                      );
                    },
                    child: groupImage == null
                        ? const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 202, 202, 202),
                            radius: 28,
                            child: Icon(
                              Icons.groups_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          )
                        : CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(groupImage!),
                          ),
                  ),
                  trailing: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: widget.groupCode));
                      Fluttertoast.showToast(
                          msg: 'Group Code copied to Clipboard');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Members : $members'),
                        Text(
                          'Group Code : ${widget.groupCode}',
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
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
