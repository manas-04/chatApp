// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          style: GoogleFonts.montserrat(
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
                    text: ' : Not updated yet!',
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
