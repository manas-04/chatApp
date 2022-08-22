// ignore_for_file: file_names

import 'package:chat_app/providers/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  void sendMessage({
    required String groupCode,
    required BuildContext context,
    required String enteredMessage,
    required TextEditingController controller,
  }) async {
    FocusScope.of(context).unfocus();
    User? user = FirebaseAuth.instance.currentUser;
    final userData = await UserHelper().fetchUser(user);

    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupCode)
        .collection('chats')
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'imageUrl': userData['imageUrl'],
      'username': userData['username'],
      'stickerUrl': null,
      'type': 'text'
    });

    controller.clear();
  }
}
