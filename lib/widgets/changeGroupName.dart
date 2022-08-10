// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeGroupNameDialogBox extends StatefulWidget {
  const ChangeGroupNameDialogBox(
      {Key? key, required this.groupName, required this.groupCode})
      : super(key: key);
  final String groupName;
  final String groupCode;

  @override
  State<ChangeGroupNameDialogBox> createState() =>
      _ChangeGroupNameDialogBoxState();
}

class _ChangeGroupNameDialogBoxState extends State<ChangeGroupNameDialogBox> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _changeName(BuildContext context, String newName) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupCode)
          .collection('details')
          .doc('generalDetails')
          .update(
        {"groupName": newName},
      );
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg:
              'Chat name updated successfully !\nRefresh the Chat List to update.');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String newName = widget.groupName;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Enter new Name',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 30,
                  ),
                  child: TextFormField(
                    initialValue: newName,
                    key: const ValueKey('name'),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Chat Name',
                      prefixIcon: const Icon(Icons.group),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      hintText: "Enter new Chat name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSaved: (value) {
                      newName = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Reason is required.";
                      } else if (value == widget.groupName) {
                        return "You cannot use the same name.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              if (!_isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _formKey.currentState!.save();
                        _changeName(context, newName);
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
