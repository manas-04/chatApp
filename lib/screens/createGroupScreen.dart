// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../components/customAppBar.dart';
import '../constants.dart';
import '../widgets/createGroupWidget.dart';

class CreateGroupScreen extends StatefulWidget {
  static const String routeName = '/CreateGroupScreen';

  const CreateGroupScreen();

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  @override
  Widget build(BuildContext context) {
    String groupCode = '';
    String groupName = '';

    setState(() {
      groupCode = getRandomString(7);
    });

    return Scaffold(
      appBar: CustomAppbar(
        showSearch: false,
        backButton: true,
        title: 'Sandesh',
      ),
      body: CreateGroupWidget(
        groupCode: groupCode,
        groupName: groupName,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(
          Icons.replay_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
