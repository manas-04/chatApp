// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ChangeGroupImageDialog extends StatefulWidget {
  const ChangeGroupImageDialog({Key? key, required this.groupCode})
      : super(key: key);
  final String groupCode;

  @override
  State<ChangeGroupImageDialog> createState() => _ChangeGroupImageDialogState();
}

class _ChangeGroupImageDialogState extends State<ChangeGroupImageDialog> {
  File? _pickedImage;
  bool _isLoading = false;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    );
    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
  }

  void _uploadImage() async {
    if (_pickedImage == null) {
      Fluttertoast.showToast(msg: 'Please pick a Group Image');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child('groupImages')
        .child(widget.groupCode + '.jpg');

    await ref.putFile(_pickedImage!);

    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupCode)
        .collection('details')
        .doc('generalDetails')
        .update(
      {"groupImage": url},
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: 'Please update the Group List to see the desired changes.');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: size * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Change group Icon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CircleAvatar(
                radius: 70,
                backgroundColor: const Color.fromARGB(255, 75, 75, 75),
                backgroundImage: _pickedImage != null
                    ? FileImage(_pickedImage!)
                    : const NetworkImage(
                            'https://thumbs.dreamstime.com/b/linear-group-icon-customer-service-outline-collection-thin-line-vector-isolated-white-background-138644548.jpg')
                        as ImageProvider,
              ),
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
            ),
            const Divider(
              color: Colors.black45,
            ),
            const Text(
              'Upload this Image ?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (!_isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      _uploadImage();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
