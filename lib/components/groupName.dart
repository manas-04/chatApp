// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/InboxScreen.dart';

class GroupName extends StatefulWidget {
  String groupName;
  final String groupCode;
  GroupName({
    required this.groupName,
    required this.groupCode,
  });

  @override
  State<GroupName> createState() => _GroupNameState();
}

class _GroupNameState extends State<GroupName> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _createGroup() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      User? user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupCode)
          .collection('details')
          .doc('generalDetails')
          .set({
        'groupCode': widget.groupCode,
        'createdAt': Timestamp.now(),
        'adminId': user.uid,
        'adminUserName': userData['username'],
        'groupName': widget.groupName,
        'groupMember': [user.uid],
        'noOfPeople': 1,
      }).then((value) async {
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          "groups": FieldValue.arrayUnion([widget.groupCode])
        }).then(
          (value) =>
              Navigator.of(context).pushNamed(GroupInbox.routeName, arguments: {
            'groupCode': widget.groupCode,
            'groupName': widget.groupName,
          }).catchError((error) {
            print(error);
          }),
        );
      }).catchError((error) {
        print(error);
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 60,
            ),
            child: TextFormField(
              key: const ValueKey('groupName'),
              decoration: InputDecoration(
                labelText: 'Group Name',
                prefixIcon: const Icon(Icons.groups_rounded),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                hintText: "Group Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onSaved: (value) {
                widget.groupName = value!;
                print(widget.groupName);
              },
              onChanged: (value) {
                print(value);
              },
              validator: (value) {
                RegExp regex = RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return "Group name is required.";
                } else if (!regex.hasMatch(value)) {
                  return "Group name must be of min. 6 characters.";
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if (!_isLoading)
          MaterialButton(
            height: 45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.white),
            ),
            elevation: 2,
            color: const Color.fromARGB(255, 197, 166, 252),
            onPressed: _createGroup,
            child: const Text(
              'Press to Initiate the Chat Creation',
              softWrap: true,
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
