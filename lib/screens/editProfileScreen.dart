// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/userProvider.dart';
import '../constants.dart';
import '../widgets/editUserImageContainer.dart';
import '../widgets/genderInput.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String bio;
  final String gender;
  final String contactNumber;
  final String imageUrl;
  final String userId;

  const EditProfileScreen(
      {Key? key,
      required this.userName,
      required this.email,
      required this.bio,
      required this.gender,
      required this.contactNumber,
      required this.imageUrl,
      required this.userId})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool _isLoading = Provider.of<UserProvider>(context).getIsLoading();

    Map<String, String?> data = {
      'userName': widget.userName,
      'gender': widget.gender,
      'bio': widget.bio,
      'imageUrl': widget.imageUrl,
      'contactNumber': widget.contactNumber,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.montserrat()),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ImageContainer(
                  size: size, pickedImage: _pickedImage, widget: widget),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: TextButton(
                  onPressed: _pickImage,
                  child: const Text('Change profile Picture'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                padding: const EdgeInsets.only(
                    top: 20, left: 15, right: 15, bottom: 3),
                child: TextFormField(
                  key: const ValueKey('userName'),
                  initialValue: widget.userName,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: const Icon(Icons.account_circle),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    hintText: "User Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSaved: (value) {
                    data['userName'] = value!;
                  },
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{4,}$');
                    if (value!.isEmpty) {
                      return "User name is required.";
                    } else if (!regex.hasMatch(value)) {
                      return "User name must be of min. 4 characters.";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                padding: const EdgeInsets.only(
                    top: 8, left: 15, right: 15, bottom: 3),
                child: TextFormField(
                  key: const ValueKey('email'),
                  initialValue: widget.email,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_rounded),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                padding: const EdgeInsets.only(
                    top: 8, left: 15, right: 15, bottom: 3),
                child: TextFormField(
                  key: const ValueKey('bio'),
                  initialValue: widget.bio,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    hintText: "Somthing that explains your personality.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSaved: (value) {
                    if (value == null) {
                      data['bio'] = "";
                    } else {
                      data['bio'] = value;
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                padding: const EdgeInsets.only(
                    top: 8, left: 15, right: 15, bottom: 3),
                child: TextFormField(
                  key: const ValueKey('Contact Number'),
                  initialValue: widget.contactNumber,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    hintText: "Your contact number.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onSaved: (value) {
                    if (value == null) {
                      data['contactNumber'] = "";
                    } else {
                      data['contactNumber'] = value;
                    }
                  },
                  validator: (value) {
                    if (value == "") {
                      return null;
                    }
                    if (value!.length != 10) {
                      return "Number should be of 10 digits";
                    }
                    return null;
                  },
                ),
              ),
              GenderInput(data: data),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _isLoading
          ? Padding(
              padding: EdgeInsets.only(left: size.width * 0.08, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(
                    color: kSecondaryColor,
                  ),
                  Text('Please wait, this will take some time.')
                ],
              ),
            )
          : FloatingActionButton.extended(
              backgroundColor: kSecondaryColor,
              onPressed: () async {
                Provider.of<UserProvider>(context, listen: false).updateUser(
                  context: context,
                  data: data,
                  formKey: _formKey,
                  pickedImage: _pickedImage,
                  userId: widget.userId,
                );
              },
              label: const Text(
                'Update Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
