// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../widgets/customAppBar.dart';
import '../widgets/groupTile.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({Key? key}) : super(key: key);
  static const String routeName = '/archivedScreen';

  @override
  State<ArchivedScreen> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Archived Chat',
        backButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                itemCount: routeArgs.length,
                itemBuilder: (context, index) => GroupTile(
                  groupCode: routeArgs[index],
                  archive: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
