// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/chatScreen.dart';

class ReportGroupDialogBox extends StatefulWidget {
  final String groupCode;

  const ReportGroupDialogBox(this.groupCode);

  @override
  State<ReportGroupDialogBox> createState() => _ReportGroupDialogBoxState();
}

class _ReportGroupDialogBoxState extends State<ReportGroupDialogBox> {
  final _formKey = GlobalKey<FormState>();

  late String report;

  void _sendReport(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    User? user = FirebaseAuth.instance.currentUser;
    print(report);
    if (isValid) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late int members;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Report this group to Snadesh ?',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
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
                  key: const ValueKey('problem'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Reason to report',
                    prefixIcon: const Icon(Icons.thumb_down),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    hintText: "Explain your reason here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSaved: (value) {
                    report = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Reason is required.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _sendReport(context);
                  },
                  child: const Text('Report'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
