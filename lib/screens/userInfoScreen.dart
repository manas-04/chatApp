// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/editProfileScreen.dart';
import '../constants.dart';
import '../widgets/UserDetail.dart';
import '../widgets/deleteUserDialogBox.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen(
      {Key? key, required this.userId, required this.showEditAndDeleteButton})
      : super(key: key);
  static const String routeName = "/userInfoScreen";
  final String userId;
  final bool showEditAndDeleteButton;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.exists &&
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
                Container(
                  width: double.infinity,
                  height: showEditAndDeleteButton
                      ? size.height * 0.65
                      : size.height * 0.7,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 206, 206, 206),
                  ),
                  child: Image.network(
                    userImage,
                    fit: BoxFit.cover,
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
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom:
                            showEditAndDeleteButton ? size.height * 0.06 : 20),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: showEditAndDeleteButton ? 10 : 0,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    height: showEditAndDeleteButton
                        ? size.height * 0.36
                        : size.height * 0.33,
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
                if (showEditAndDeleteButton)
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
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteUserDialogBox(
                                  parentContext: context,
                                );
                              });
                        },
                      ),
                    ),
                  ),
                if (showEditAndDeleteButton)
                  Positioned(
                      right: size.width * 0.08,
                      bottom: size.height * 0.39,
                      child: CircleAvatar(
                        radius: 28,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          iconSize: 30,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        EditProfileScreen(
                                  userId: userId,
                                  userName: username,
                                  email: email,
                                  bio: bio,
                                  gender: gender,
                                  contactNumber: contactNo,
                                  imageUrl: userImage,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.fastOutSlowIn;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
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
