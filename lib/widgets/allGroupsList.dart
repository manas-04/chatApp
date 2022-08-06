// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../components/archivedBar.dart';
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
        const ArchivedBar(),
        if (widget.groupData.isNotEmpty)
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                itemCount: widget.groupData.length,
                itemBuilder: (context, index) => GroupTile(
                  groupCode: widget.groupData[index],
                  archive: false,
                ),
              ),
            ),
          ),
        if (widget.groupData.isEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/waiting.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "You don't have any chat here.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
