// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportGroupDialogBox extends StatefulWidget {
  final String groupCode;

  const ReportGroupDialogBox(this.groupCode);

  @override
  State<ReportGroupDialogBox> createState() => _ReportGroupDialogBoxState();
}

class _ReportGroupDialogBoxState extends State<ReportGroupDialogBox> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String report;

  void _sendReport(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();

    User? user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      final doc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupCode)
          .collection('details')
          .doc('reports')
          .get();
      if (doc.exists) {
        FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupCode)
            .collection('details')
            .doc('reports')
            .update(
          {
            'reports': FieldValue.arrayUnion(
              [
                {
                  'report': report,
                  'userId': user.uid,
                  'createdAt': Timestamp.now(),
                  'username': userData['username'],
                }
              ],
            ),
          },
        );
      } else {
        FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupCode)
            .collection('details')
            .doc('reports')
            .set(
          {
            'reports': FieldValue.arrayUnion(
              [
                {
                  'report': report,
                  'userId': user.uid,
                  'createdAt': Timestamp.now(),
                  'username': userData['username'],
                }
              ],
            ),
          },
        );
      }

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Report has been sent.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 0.52,
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
                        _sendReport(context);
                      },
                      child: const Text('Report'),
                    ),
                  ],
                ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
