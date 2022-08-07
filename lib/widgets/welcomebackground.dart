// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Background({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/main_top.png"),
            width: size.width * 0.4,
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Image.asset("assets/images/main_bottom.png"),
            width: size.width * 0.4,
          ),
          Positioned(
            child: Image.asset("dev_assets/beeLogoAdaptive.png"),
            width: size.width * 0.3,
            bottom: -10,
            right: -10,
          ),
          Container(
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }
}
