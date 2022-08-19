// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stickerProvider.dart';

class UserStickers extends StatelessWidget {
  UserStickers({
    Key? key,
    required this.groupCode,
    required this.textController,
  }) : super(key: key);
  final String groupCode;

  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.hasData &&
              dataSnapshot.connectionState == ConnectionState.active) {
            final data = dataSnapshot.data!.get('stickerUrl') as List<dynamic>;
            return Expanded(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => StickerProvider(),
                  )
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                      ),
                      physics: const ScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<StickerProvider>(context, listen: false)
                                .sendSticker(
                              groupCode,
                              data[index],
                              textController,
                              context,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 206, 206, 206),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(data[index]),
                          ),
                        );
                      }),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
