// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chats/messageBubble.dart';

class Messages extends StatelessWidget {
  const Messages(this.groupCode);
  final String groupCode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(groupCode)
                .collection("chats")
                .orderBy(
                  "createdAt",
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final document = chatSnapshot.data!.docs;

              return ListView.builder(
                itemCount: document.length,
                reverse: true,
                itemBuilder: ((context, index) => MessageBubble(
                      message: document[index]['text'] ??
                          document[index]['stickerUrl'],
                      isSameUser:
                          document[index]['userId'] == snapShot.data!.uid,
                      userName: document[index]['username'],
                      messageId: document[index].id,
                      userImage: document[index]['imageUrl'],
                      key: ValueKey(document[index].id),
                      groupCode: groupCode,
                      type: document[index]['type'],
                    )),
              );
            });
      },
    );
  }
}
