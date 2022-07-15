// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/logOutDialogBox.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showSearch;

  const CustomAppbar({
    Key? key,
    this.showSearch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: const Text('Sandesh'),
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
