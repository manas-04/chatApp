// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../widgets/changeGroupDialogBox.dart';
import '../widgets/changeGroupName.dart';

class GroupSettingsScreen extends StatelessWidget {
  static const String routeName = '/groupSettings';
  const GroupSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String groupCode = routeArgs['groupCode'] as String;
    final String groupName = routeArgs['groupName'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Settings"),
      ),
      body: Column(
        children: [
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
                'Change Chat Image',
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
                'Change Chat Name',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
