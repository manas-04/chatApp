// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../widgets/joinGroupModalSheet.dart';
import '../screens/createGroupScreen.dart';
import '../widgets/filledOutButton.dart';
import '../constants.dart';

class ButtonRow extends StatefulWidget {
  const ButtonRow({
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      color: kPrimaryColor,
      child: Row(
        children: [
          FillOutlineButton(
            press: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CreateGroupScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeOut;

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
            text: "Create a Chat Stream",
            isFilled: true,
          ),
          const SizedBox(
            width: 15,
          ),
          FillOutlineButton(
            press: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return const JoinChatModalSheet();
                  });
            },
            //   Navigator.push(
            //     context,
            //     PageRouteBuilder(
            //       pageBuilder: (context, animation, secondaryAnimation) =>
            //           const JoinScreen(),
            //       transitionsBuilder:
            //           (context, animation, secondaryAnimation, child) {
            //         const begin = Offset(1.0, 0.0);
            //         const end = Offset.zero;
            //         const curve = Curves.easeOut;

            //         var tween = Tween(begin: begin, end: end)
            //             .chain(CurveTween(curve: curve));

            //         return SlideTransition(
            //           position: animation.drive(tween),
            //           child: child,
            //         );
            //       },
            //     ),
            //   );
            // },
            text: "Join a Chat Stream",
            isFilled: true,
          ),
        ],
      ),
    );
  }
}
