// ignore_for_file: must_be_immutable, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RemoveStickerDialogBox extends StatelessWidget {
  RemoveStickerDialogBox({
    Key? key,
    required this.id,
    required this.imageUrl,
  }) : super(key: key);
  final String id;
  final String imageUrl;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Do you want to remove this sticker \nfrom your collection ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final doc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .get();

                      final stickerIds =
                          doc.data()!['stickerId'] as List<dynamic>;
                      if (stickerIds.contains(id)) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .update({
                          "stickerId": FieldValue.arrayRemove([id]),
                          "stickerUrl": FieldValue.arrayRemove([imageUrl])
                        });
                        Fluttertoast.showToast(
                            msg: 'Sticker removed from your collection');
                      } else {
                        Fluttertoast.showToast(
                            msg: 'This sticker has been already removed.');
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
