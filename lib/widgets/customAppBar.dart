// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/logOutDialogBox.dart';
import '../screens/userInfoScreen.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;
  final String title;
  final bool backButton;

  CustomAppbar({
    Key? key,
    this.showSearch = true,
    required this.title,
    required this.backButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return AppBar(
      automaticallyImplyLeading: backButton,
      title: Text(title),
      actions: [
        if (showSearch == true)
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserInfoScreen(
                        userId: user!.uid,
                        showEditAndDeleteButton: true,
                      )));
            },
            icon: const Icon(Icons.person_rounded),
          ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const LogOutDialogBox(),
          ),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
