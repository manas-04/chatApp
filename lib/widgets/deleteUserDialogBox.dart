// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../providers/userProvider.dart';
import 'package:provider/provider.dart';

class DeleteUserDialogBox extends StatefulWidget {
  const DeleteUserDialogBox({
    Key? key,
    required this.parentContext,
  }) : super(key: key);
  final BuildContext parentContext;

  @override
  State<DeleteUserDialogBox> createState() => _DeleteUserDialogBoxState();
}

class _DeleteUserDialogBoxState extends State<DeleteUserDialogBox> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.55,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Are you sure ?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Deleting this account will result in complete removal of your account from the database and all the information associated with it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
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
                        setState(() {
                          _isLoading = true;
                        });
                        Provider.of<UserProvider>(context, listen: false)
                            .deleteUser(context);
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
