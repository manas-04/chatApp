// ignore_for_file: file_names, avoid_unnecessary_containers, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/customAppBar.dart';
import '../widgets/allGroupsList.dart';
import '../widgets/NoGroupSection.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/ChatScreen';
  const ChatScreen();

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backButton: false,
        title: 'Sandesh',
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasData &&
              dataSnapshot.data != null &&
              dataSnapshot.data!.exists &&
              dataSnapshot.connectionState == ConnectionState.active) {
            final data = dataSnapshot.data!.get('groups') as List<dynamic>;
            if (data.isNotEmpty) {
              return AllGroupsList(groupData: data.reversed.toList());
            } else {
              return const NoGroupScreen();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
