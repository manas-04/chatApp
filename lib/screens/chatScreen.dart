// ignore_for_file: file_names, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../components/customAppBar.dart';
import '../widgets/NoGroupSection.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(),
      body: NoGroupScreen(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/3yYjYxLVNrDJLpDplDJb/messages')
      //         .add({'text': 'New entry added !!'});
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
