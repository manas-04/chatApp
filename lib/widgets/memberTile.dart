// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../providers/userGroupProvider.dart';

class MemberTile extends StatelessWidget {
  const MemberTile({
    Key? key,
    required this.membersList,
    required this.adminId,
    required this.groupCode,
  }) : super(key: key);

  final List membersList;
  final String groupCode;
  final String adminId;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final bool isUserAdmin = user!.uid == adminId;

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
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: ListTile(
                        title: Text(userName),
                        subtitle: Text(email),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 212, 212, 212),
                          backgroundImage: NetworkImage(userImage),
                        ),
                        trailing: isUserAdmin && adminId != membersList[index]
                            ? RemoveMemberButton(
                                memberId: membersList[index],
                                groupCode: groupCode,
                                user: user,
                                parentContext: context,
                              )
                            : null),
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

class RemoveMemberButton extends StatelessWidget {
  const RemoveMemberButton({
    Key? key,
    required this.memberId,
    required this.groupCode,
    required this.user,
    required this.parentContext,
  }) : super(key: key);
  final String memberId;
  final String groupCode;
  final User? user;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Are you sure, you want to \nremove this person ?',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Provider.of<UserGroupProvider>(parentContext,
                                    listen: false)
                                .removeGroupMember(groupCode, memberId);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg:
                                    'Please refresh to update the Group List.');
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.remove_circle_outline_rounded,
        color: Colors.red,
      ),
    );
  }
}
