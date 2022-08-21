// ignore_for_file: file_names, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File? pickedImage) imagePicFn;

  const UserImagePicker(this.imagePicFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 800,
    );
    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.imagePicFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CircleAvatar(
            radius: 50,
            // backgroundColor: const Color.fromARGB(255, 155, 155, 155),
            backgroundImage: _pickedImage != null
                ? FileImage(_pickedImage!)
                : const NetworkImage(
                        'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg')
                    as ImageProvider,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
