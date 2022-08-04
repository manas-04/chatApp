// ignore_for_file: file_names, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/archiveData.dart';
import '../screens/archivedScreen.dart';

class ArchivedBar extends StatelessWidget {
  const ArchivedBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final document = snapShot.data!.get('archivedGroups') as List<dynamic>;
        if (document.isEmpty) {
          return const ArchivedData(
            hasData: false,
            length: 0,
          );
        }

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ArchivedScreen.routeName,
              arguments: document,
            );
          },
          child: ArchivedData(
            hasData: true,
            length: document.length,
          ),
        );
      },
    );
  }
}
