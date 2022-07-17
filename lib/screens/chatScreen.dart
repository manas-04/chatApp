// ignore_for_file: file_names, avoid_unnecessary_containers, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/customAppBar.dart';
import '../widgets/allGroupsList.dart';
import '../widgets/NoGroupSection.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen();

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool hasGroup = false;

  @override
  void didChangeDependencies() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final groupsData = userData['groups'] as List<dynamic>;
    print(groupsData.isNotEmpty);
    if (groupsData.isNotEmpty) {
      setState(() {
        hasGroup = true;
      });
    } else {
      setState(() {
        hasGroup = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Sandesh',
      ),
      body: hasGroup
          ? const Center(
              child: AllGroupsList(),
            )
          : const NoGroupScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newData = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
          final groupsData = newData['groups'] as List<dynamic>;
          if (groupsData.isNotEmpty) {
            setState(() {
              hasGroup = true;
            });
          } else {
            setState(() {
              hasGroup = false;
            });
          }
        },
        child: const Icon(
          Icons.replay_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
