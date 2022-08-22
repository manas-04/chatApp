// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:chat_app/providers/messageProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../widgets/stickerButton.dart';

class NewMessage extends StatefulWidget {
  const NewMessage(this.groupCode);
  final String groupCode;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    Provider.of<MessageProvider>(context, listen: false).sendMessage(
      context: context,
      controller: controller,
      enteredMessage: _enteredMessage,
      groupCode: widget.groupCode,
    );
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          const Divider(
            color: Colors.black54,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                StickerButton(
                  groupCode: widget.groupCode,
                  textController: controller,
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Type a message...',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
