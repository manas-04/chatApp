// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../components/groupTile.dart';
import '../components/buttonRow.dart';

class AllGroupsList extends StatelessWidget {
  final List<dynamic> groupData;

  const AllGroupsList({Key? key, required this.groupData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ButtonRow(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                const Duration(
                  milliseconds: 1000,
                ),
              );
            },
            child: ListView.builder(
              itemCount: groupData.length,
              itemBuilder: (context, index) => GroupTile(
                groupCode: groupData[index],
              ),
            ),
          ),
        )
      ],
    );
  }
}
