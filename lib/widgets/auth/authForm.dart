// ignore_for_file: file_names, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../auth/userImagePicker.dart';
import '../button.dart';
import '../titleSection.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  final bool isLoading;
  bool _isLogin;
  final void Function(
    String email,
    String username,
    String password,
    File userImage,
    bool isLogin,
  ) submitFn;

  AuthForm(this.submitFn, this.isLoading, this._isLogin);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  // bool _isLogin = true;
  String userEmail = '';
  String userName = '';
  String password = '';
  File? userImage;
  bool obscureText = true;

  void _userImagePicker(File? image) {
    userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (userImage == null && !widget._isLogin) {
      Fluttertoast.showToast(
          msg: 'Please pick an Image to create a new profile.');
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(userEmail.trim(), userName, password.trim(),
          userImage == null ? File('') : userImage!, widget._isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: widget._isLogin
              ? const AssetImage('assets/images/loginBackground.png')
              : const AssetImage('assets/images/registerBackground.png'),
          fit: BoxFit.fill,
        ),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleSection(widget._isLogin),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!widget._isLogin) UserImagePicker(_userImagePicker),
                        const SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: TextFormField(
                            key: const ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email.";
                              } else if (!RegExp(
                                      '^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                                  .hasMatch(value)) {
                                return "Please enter a valid email.";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              userEmail = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.person),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        if (!widget._isLogin)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: TextFormField(
                              key: const ValueKey('userName'),
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
                                userName = value!;
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: TextFormField(
                            key: const ValueKey('password'),
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return "Please enter a Password.";
                              } else if (!regex.hasMatch(value)) {
                                return "Enter a valid password minimum 6 characters long.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        if (widget.isLoading)
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Please wait, it will take a moment !',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        if (!widget.isLoading)
                          Button(widget._isLogin, _trySubmit),
                        if (!widget.isLoading)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                widget._isLogin = !widget._isLogin;
                              });
                            },
                            child: Text(
                              widget._isLogin
                                  ? "Dont't have an account ? SignUp."
                                  : 'Already have an Account.',
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
