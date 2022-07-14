// ignore_for_file: file_names

import 'package:chat_app/screens/authScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/welcomeButton.dart';
import '../widgets/welcomebackground.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void clickOnLogin() {
      Navigator.pushNamed(
        context,
        AuthScreen.routeName,
        arguments: true,
      );
    }

    void clickOnSignUp() {
      Navigator.pushNamed(
        context,
        AuthScreen.routeName,
        arguments: false,
      );
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                alignment: Alignment.center,
                child: const Text(
                  'Welcome to Sandesh',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: size.height * 0.1),
                child: SvgPicture.asset(
                  "assets/images/chat.svg",
                  height: size.height * 0.4,
                ),
              ),
              WelcomeButton(
                size: size,
                text: "LOGIN",
                color: Colors.deepPurple,
                pushFunction: clickOnLogin,
              ),
              WelcomeButton(
                size: size,
                text: "SIGN UP",
                color: const Color.fromARGB(255, 195, 163, 255),
                pushFunction: clickOnSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
