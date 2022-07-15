// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../screens/createGroupScreen.dart';
import '../constants.dart';
import '../components/button.dart';
import '../components/filledOutButton.dart';

class NoGroupScreen extends StatelessWidget {
  const NoGroupScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            color: kPrimaryColor,
            child: Row(
              children: [
                FillOutlineButton(
                  press: () {},
                  text: "Recent Messages",
                ),
                const SizedBox(
                  width: 15,
                ),
                FillOutlineButton(
                  press: () {},
                  text: "Active",
                  isFilled: false,
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.2),
            child: Image.asset('dev_assets/beeLogoAdaptive.png'),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Start a Conversation !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Button(trySubmit: () {}, text: 'Join a Conversation'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.5),
            child: Button(
              trySubmit: () {
                Navigator.of(context).pushNamed(CreateGroupScreen.routeName);
              },
              text: 'Generate a Chat Code',
            ),
          ),
          // const Expanded(
          //   child: Messages(),
          // ),
          // const NewMessage(),
        ],
      ),
    );
  }
}
