// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StickerProvider with ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  void addStickerToUser(String id, String imageUrl) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    final stickerIds = doc.data()!['stickerId'] as List<dynamic>;
    if (stickerIds.contains(id)) {
      Fluttertoast.showToast(msg: 'You already have this sticker.');
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "stickerId": FieldValue.arrayUnion([id]),
        "stickerUrl": FieldValue.arrayUnion([imageUrl])
      });
      Fluttertoast.showToast(msg: 'Sticker added to your collection');
    }
    notifyListeners();
  }

  void sendSticker(String groupCode, String imageUrl,
      TextEditingController controller, BuildContext context) async {
    FocusScope.of(context).unfocus();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupCode)
        .collection('chats')
        .add({
      'text': null,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'stickerUrl': imageUrl,
      'imageUrl': userData['imageUrl'],
      'username': userData['username'],
      'type': 'sticker'
    });
    Navigator.of(context).pop();
    notifyListeners();
  }

  void deleteStickerFromCollection() {}
}
