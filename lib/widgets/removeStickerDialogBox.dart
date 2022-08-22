// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/stickerProvider.dart';

class RemoveStickerDialogBox extends StatelessWidget {
  const RemoveStickerDialogBox({
    Key? key,
    required this.id,
    required this.imageUrl,
  }) : super(key: key);
  final String id;
  final String imageUrl;

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
                      Provider.of<StickerProvider>(
                        context,
                        listen: false,
                      ).deleteStickerFromCollection(
                        context,
                        id,
                        imageUrl,
                      );
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
