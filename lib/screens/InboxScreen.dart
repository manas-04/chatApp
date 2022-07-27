// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../chats/messages.dart';
import '../chats/newMessage.dart';
import '../components/customAppBar.dart';

class GroupInbox extends StatelessWidget {
  static const String routeName = '/GroupInbox';

  const GroupInbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final String groupCode = routeArgs['groupCode'] as String;
    final String groupName = routeArgs['groupName'] as String;

    return Scaffold(
      appBar: CustomAppbar(
        backButton: true,
        title: groupName,
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(groupCode),
          ),
          NewMessage(groupCode),
        ],
      ),
    );
  }
}
