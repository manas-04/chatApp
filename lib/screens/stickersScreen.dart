// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stickerProvider.dart';
import '../widgets/customAppBar.dart';

class StickersScreen extends StatelessWidget {
  const StickersScreen({Key? key}) : super(key: key);
  static const String routeName = '/stickerScreen';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Stickers',
        backButton: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('stickers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => StickerProvider(),
                  )
                ],
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                            width: size.width * 0.22,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Image.network(document[index]['imageUrl']),
                              ),
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(
                              Icons.download_rounded,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              Provider.of<StickerProvider>(
                                context,
                                listen: false,
                              ).addStickerToUser(document[index].id,
                                  document[index]['imageUrl']);
                            },
                            label: const Text(
                              'Add Sticker',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
