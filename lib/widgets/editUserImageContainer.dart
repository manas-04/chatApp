// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/editProfileScreen.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    Key? key,
    required this.size,
    required File? pickedImage,
    required this.widget,
  })  : _pickedImage = pickedImage,
        super(key: key);

  final Size size;
  final File? _pickedImage;
  final EditProfileScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: size.height * 0.2,
        width: size.height * 0.2,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 206, 206, 206),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: const Color.fromARGB(255, 94, 94, 94), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: _pickedImage == null
              ? Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  frameBuilder:
                      ((context, child, frame, wasSynchronouslyLoaded) =>
                          child),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                  },
                )
              : Image.file(
                  _pickedImage!,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
