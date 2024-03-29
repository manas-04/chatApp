// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupDescription extends StatelessWidget {
  const GroupDescription({
    Key? key,
    required this.groupName,
    required this.adminName,
    required this.createdDate,
    required this.groupCode,
    required this.groupImage,
  }) : super(key: key);

  final String groupCode;
  final String groupName;
  final String adminName;
  final String? groupImage;
  final Timestamp createdDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.34,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (groupImage == null)
              Hero(
                tag: groupCode,
                child: const CircleAvatar(
                  child: Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  radius: 50,
                  backgroundColor: Color.fromARGB(255, 216, 216, 216),
                ),
              ),
            if (groupImage != null)
              Hero(
                tag: groupCode,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color.fromARGB(255, 216, 216, 216),
                  backgroundImage: NetworkImage(groupImage!),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                groupName,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Text(
                'Admin : $adminName',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Text(
                'Created on : ${DateFormat.yMMMMEEEEd().format(
                  DateTime.fromMicrosecondsSinceEpoch(
                      createdDate.microsecondsSinceEpoch),
                )}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
