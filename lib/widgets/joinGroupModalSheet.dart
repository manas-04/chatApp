// ignore_for_file: file_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screens/InboxScreen.dart';

class JoinChatModalSheet extends StatefulWidget {
  static const String routeName = "/JoinGroupScreen";
  const JoinChatModalSheet({Key? key}) : super(key: key);

  @override
  State<JoinChatModalSheet> createState() => _JoinChatModalSheetState();
}

class _JoinChatModalSheetState extends State<JoinChatModalSheet> {
  final _formKey = GlobalKey<FormState>();
  late String code;
  bool _isLoading = false;
  late int members;
  late String groupName;
  late List<dynamic> membersList;

  void _findGroup() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    User? user = FirebaseAuth.instance.currentUser;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      var docRef = await FirebaseFirestore.instance
          .collection('groups')
          .doc(code)
          .collection('details')
          .doc('generalDetails')
          .get();

      if (docRef.exists) {
        membersList = docRef.get('groupMember') as List<dynamic>;
        if (membersList.contains(user!.uid)) {
          Fluttertoast.showToast(msg: "You are already a part of this group.");
        } else {
          members = docRef.get('noOfPeople') as int;
          groupName = docRef.get('groupName') as String;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            "groups": FieldValue.arrayUnion([code])
          });
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(code)
              .collection('details')
              .doc('generalDetails')
              .update({
            "noOfPeople": members + 1,
            "groupMember": FieldValue.arrayUnion([user.uid])
          }).then((value) {
            Navigator.of(context).pushNamed(GroupInbox.routeName,
                arguments: {"groupCode": code, "groupName": groupName});
          }).catchError((error) {
            print(error);
          });
        }
      } else {
        Fluttertoast.showToast(msg: "No such chat group exists");
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Enter the chat code below :",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 60,
                  ),
                  child: TextFormField(
                    key: const ValueKey('code'),
                    decoration: InputDecoration(
                      labelText: 'Group Code',
                      prefixIcon: const Icon(Icons.groups_rounded),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      hintText: "Enter Code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSaved: (value) {
                      code = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Group Code is required.";
                      } else if (value.length > 7 || value.length < 7) {
                        return "Group Code must be of 7 characters.";
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
                  onPressed: _findGroup,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Press to initiate the Join process >>',
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            ],
          ),
        ),
      ),
    );
  }
}
