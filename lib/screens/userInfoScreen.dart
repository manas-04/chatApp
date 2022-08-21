// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

// import '../widgets/logOutDialogBox.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);
  static const String routeName = "/userInfoScreen";

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          final userImage = snapshot.data!.get('imageUrl') as String;
          final username = snapshot.data!.get('username') as String;
          final email = snapshot.data!.get('email') as String;
          final bio = snapshot.data!.get('bio') as String;
          final gender = snapshot.data!.get('gender') as String;
          final groups = snapshot.data!.get('groups') as List<dynamic>;
          final contactNo = snapshot.data!.get('number') as String;
          final archivedGroups =
              snapshot.data!.get('archivedGroups') as List<dynamic>;
          return Scaffold(
            body: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.65,
                  child: Image.network(
                    userImage,
                    fit: BoxFit.fitHeight,
                    frameBuilder:
                        ((context, child, frame, wasSynchronouslyLoaded) =>
                            child),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: size.height * 0.1,
                            child: const Text('Loading....'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: size.height * 0.06),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    height: size.height * 0.36,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, left: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.raleway(
                                fontSize: 38,
                              ),
                            ),
                            DetailInfo(
                                info: email, infoTitle: "Email", size: 24),
                            DetailInfo(infoTitle: "Bio", info: bio, size: 20),
                            DetailInfo(
                                infoTitle: "Gender", info: gender, size: 20),
                            DetailInfo(
                                info: contactNo,
                                infoTitle: "Contact number",
                                size: 20),
                            const SizedBox(
                              height: 26,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Total Groups : ${groups.length + archivedGroups.length}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Archived Groups : ${archivedGroups.length}",
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kErrorColor,
                    ),
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Delete account',
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Positioned(
                    right: size.width * 0.08,
                    bottom: size.height * 0.39,
                    child: CircleAvatar(
                      radius: 28,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        iconSize: 30,
                        onPressed: () {},
                      ),
                    ))
              ],
            ),
          );
        }
        return const Scaffold();
      },
    );
  }
}

class DetailInfo extends StatelessWidget {
  const DetailInfo({
    Key? key,
    required this.info,
    required this.infoTitle,
    required this.size,
  }) : super(key: key);

  final String info;
  final String infoTitle;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: 2,
        right: 10,
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.raleway(
            fontSize: size,
            color: Colors.black,
          ),
          children: info.isEmpty
              ? [
                  TextSpan(
                    text: infoTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text: ' : User has not updated it yet!',
                  ),
                ]
              : [
                  TextSpan(
                    text: infoTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' : $info ',
                  ),
                ],
        ),
      ),
    );
  }
}