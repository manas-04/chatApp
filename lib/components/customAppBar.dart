// ignore_for_file: file_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../components/logOutDialogBox.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;
  final String title;

  CustomAppbar({
    Key? key,
    this.showSearch = true,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Text(title),
      actions: [
        if (showSearch == true)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
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
  Size get preferredSize => const Size.fromHeight(60);
}
