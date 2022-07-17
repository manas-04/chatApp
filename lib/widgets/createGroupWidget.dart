// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

import '../components/groupName.dart';
import '../components/groupCodeString.dart';

class CreateGroupWidget extends StatelessWidget {
  CreateGroupWidget({
    Key? key,
    required this.groupCode,
    required this.groupName,
  }) : super(key: key);

  final String groupCode;
  String groupName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset('dev_assets/beeLogoAdaptive.png'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Here is your new group Code : ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GroupCodeString(groupCode),
            GroupName(
              groupName: groupName,
              groupCode: groupCode,
            ),
          ],
        ),
      ),
    );
  }
}
