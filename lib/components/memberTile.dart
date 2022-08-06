// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberTile extends StatelessWidget {
  const MemberTile({
    Key? key,
    required this.membersList,
  }) : super(key: key);

  final List membersList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: membersList.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
              future: Future.value(
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(membersList[index])
                    .get(),
              ),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData &&
                    userSnapshot.connectionState == ConnectionState.done) {
                  final String userName =
                      userSnapshot.data!.get('username') as String;
                  final String email =
                      userSnapshot.data!.get('email') as String;
                  final String userImage =
                      userSnapshot.data!.get('imageUrl') as String;
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: ListTile(
                      title: Text(userName),
                      subtitle: Text(email),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                      ),
                    ),
                  );
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
