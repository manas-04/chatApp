// ignore_for_file: file_names, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/components/filledOutButton.dart';
import '../chats/messages.dart';
import '../chats/newMessage.dart';
import '../widgets/components/logOutDialogBox.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sandesh'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const LogOutDialogBox(),
            ),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              color: kPrimaryColor,
              child: Row(
                children: [
                  FillOutlineButton(
                    press: () {},
                    text: "Recent Messages",
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FillOutlineButton(
                    press: () {},
                    text: "Active",
                    isFilled: false,
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Messages(),
            ),
            const NewMessage(),
          ],
        ),
      ),
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
