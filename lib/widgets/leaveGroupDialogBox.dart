// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userGroupProvider.dart';

class LeaveGroupDialogBox extends StatelessWidget {
  final String groupCode;

  const LeaveGroupDialogBox(this.groupCode);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
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
                      Provider.of<UserGroupProvider>(context, listen: false)
                          .leaveGroup(groupCode, context);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
