// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TitleSection extends StatelessWidget {
  final bool isLogin;

  const TitleSection(this.isLogin);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLogin
                ? SizedBox(
                    height: 250,
                    child: SvgPicture.asset(
                      'assets/images/login.svg',
                    ),
                  )
                : null,
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: isLogin
                ? EdgeInsets.only(
                    top: 10,
                    left: MediaQuery.of(context).size.width * 0.12,
                  )
                : const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  isLogin ? 'Welcome Back' : 'Sign Up',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isLogin
                      ? 'Please Sign In to Continue.'
                      : 'Create your new Account here.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
