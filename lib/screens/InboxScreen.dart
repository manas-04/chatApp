// ignore_for_file: file_names
import 'package:chat_app/screens/groupInfoScreen.dart';
import 'package:flutter/material.dart';

import '../components/leaveGroupDialogBox.dart';
import '../chats/messages.dart';
import '../chats/newMessage.dart';
import '../components/logOutDialogBox.dart';

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
      appBar: AppBar(
        title: Text(groupName),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'search') {
              } else if (value == 'chatInfo') {
                Navigator.of(context)
                    .pushNamed(GroupInfoScreen.routeName, arguments: {
                  "groupCode": groupCode,
                  "groupName": groupName,
                });
              } else if (value == 'leaveGroup') {
                showDialog(
                  context: context,
                  builder: (context) => LeaveGroupDialogBox(groupCode),
                );
              } else if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (context) => const LogOutDialogBox(),
                );
              } else if (value == "settings") {}
            },
            constraints: const BoxConstraints(minWidth: 180),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                value: 'search',
                child: Row(
                  children: const [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Search'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'chatInfo',
                child: Row(
                  children: const [
                    Icon(
                      Icons.group_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Chat Info'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Leave Group'),
                  ],
                ),
                value: 'leaveGroup',
              ),
              PopupMenuItem(
                enabled: false,
                value: 'settings',
                child: Row(
                  children: const [
                    Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/doodle.jpg'),
            opacity: 0.6,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Messages(groupCode),
            ),
            NewMessage(groupCode),
          ],
        ),
      ),
    );
  }
}
