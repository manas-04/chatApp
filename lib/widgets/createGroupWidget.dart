// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/groupCodeString.dart';

class CreateGroupWidget extends StatelessWidget {
  const CreateGroupWidget({
    Key? key,
    required this.groupCode,
  }) : super(key: key);

  final String groupCode;

  void _createGroup() async {
    User? user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupCode)
        .collection('details')
        .add({
      'groupCode': groupCode,
      'createdAt': Timestamp.now(),
      'adminId': user.uid,
      'imageUrl': userData['imageUrl'],
      'adminUserName': userData['username'],
      'noOfPeople': 1,
    }).then((value) {
      print(value.id);
      //User mein ek field banana hai Groups karke aur har group ka id add karwana hai
      //Add group name feature as well
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('dev_assets/beeLogoAdaptive.png'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Here is your new group Code : ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          GroupCodeString(groupCode),
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
              'Initiate the Group Creation',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
