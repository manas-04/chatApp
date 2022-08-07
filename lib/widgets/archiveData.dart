// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:flutter/material.dart';

import '../constants.dart';

class ArchivedData extends StatelessWidget {
  final bool hasData;
  final int length;

  const ArchivedData({
    required this.hasData,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.archive_outlined,
                  color: hasData ? kPrimaryColor : Colors.grey,
                  size: 26,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Archived',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              length.toString(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
