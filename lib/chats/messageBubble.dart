// ignore_for_file: file_names, use_key_in_widget_constructors, overridden_fields, annotate_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isSameUser;
  final String messageId;
  final String userImage;
  final Key key;
  final String groupCode;

  const MessageBubble({
    required this.message,
    required this.isSameUser,
    required this.userName,
    required this.messageId,
    required this.userImage,
    required this.key,
    required this.groupCode,
  });

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupCode)
                  .collection('chats')
                  .doc(messageId)
                  .delete();
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20,
              ),
              child: Text('Unsend Message'),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      duration: const Duration(
        milliseconds: 2000,
      ),
    );

    return GestureDetector(
      onLongPress: () {
        if (isSameUser) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment:
                  isSameUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isSameUser
                        ? const Color.fromARGB(255, 46, 177, 238)
                        : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: isSameUser
                          ? const Radius.circular(0)
                          : const Radius.circular(14),
                      bottomLeft: !isSameUser
                          ? const Radius.circular(0)
                          : const Radius.circular(14),
                      bottomRight: const Radius.circular(14),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.42,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: !isSameUser
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: -20,
              left: !isSameUser
                  ? MediaQuery.of(context).size.width * 0.38
                  : MediaQuery.of(context).size.width * 0.52,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ),
            ),
          ],
          clipBehavior: Clip.none,
        ),
      ),
    );
  }
}
