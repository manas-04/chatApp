import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chats/messageBubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

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
                .collection('chats')
                .orderBy(
                  'createdAt',
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
                      message: document[index]['text'],
                      isSameUser:
                          document[index]['userId'] == snapShot.data!.uid,
                      userName: document[index]['username'],
                      messageId: document[index].id,
                      userImage: document[index]['imageUrl'],
                      key: ValueKey(document[index].id),
                    )),
              );
            });
      },
    );
  }
}
