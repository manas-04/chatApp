// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../components/groupTile.dart';
import '../components/buttonRow.dart';

class AllGroupsList extends StatefulWidget {
  final List<dynamic> groupData;

  const AllGroupsList({Key? key, required this.groupData}) : super(key: key);

  @override
  State<AllGroupsList> createState() => _AllGroupsListState();
}

class _AllGroupsListState extends State<AllGroupsList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ButtonRow(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              itemCount: widget.groupData.length,
              itemBuilder: (context, index) => GroupTile(
                groupCode: widget.groupData[index],
              ),
            ),
          ),
        )
      ],
    );
  }
}
