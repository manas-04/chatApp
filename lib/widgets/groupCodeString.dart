// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupCodeString extends StatelessWidget {
  const GroupCodeString(this.groupCode);

  final String groupCode;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.only(left: 16, right: 6),
        color: Colors.amberAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              groupCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 50,
                width: 50,
                color: const Color.fromARGB(255, 245, 245, 245),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: groupCode));
                    Fluttertoast.showToast(msg: 'Code copied to Clipboard');
                  },
                  icon: const Icon(
                    Icons.copy,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
