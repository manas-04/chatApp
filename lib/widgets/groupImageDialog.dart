// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/groupInfoScreen.dart';
import '../widgets/reportGroupDialogBox.dart';

class GroupImageDialog extends StatefulWidget {
  GroupImageDialog({
    required this.groupName,
    required this.groupCode,
    required this.groupImage,
    required this.members,
    required this.adminName,
    required this.createdDate,
    required this.membersList,
    required this.showinfo,
    required this.adminId,
  });
  final String groupName;
  final String groupCode;
  final String? groupImage;
  final int members;
  final String adminName;
  final Timestamp createdDate;
  final List<dynamic> membersList;
  final bool showinfo;
  final String adminId;

  @override
  State<GroupImageDialog> createState() => _GroupImageDialogState();
}

class _GroupImageDialogState extends State<GroupImageDialog> {
  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: size * 0.6,
        width: size * 0.42,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.groupName,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            if (widget.groupImage == null)
              SizedBox(
                height: size * 0.3,
                child: CircleAvatar(
                  radius: size * 0.115,
                  backgroundColor: const Color.fromARGB(255, 207, 207, 207),
                  child: Icon(
                    Icons.groups_rounded,
                    size: size * 0.15,
                    color: Colors.white,
                  ),
                ),
              ),
            if (widget.groupImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: size * 0.4,
                  width: size * 0.3,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurStyle: BlurStyle.outer)
                    ],
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.groupImage!),
                    ),
                  ),
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.showinfo)
                    SizedBox(
                      width: size * 0.15,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(GroupInfoScreen.routeName, arguments: {
                            "groupCode": widget.groupCode,
                            "groupName": widget.groupName,
                            "groupImage": widget.groupImage,
                            "adminName": widget.adminName,
                            "members": widget.members,
                            "createdDate": widget.createdDate,
                            "membersList": widget.membersList,
                            "adminId": widget.adminId,
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.info_outline_rounded),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Group Info'),
                            )
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: size * 0.15,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ReportGroupDialogBox(widget.groupCode),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.report),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('Report'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
