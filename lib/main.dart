// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:chat_app/screens/InboxScreen.dart';
import 'package:chat_app/screens/chatScreen.dart';
import 'package:chat_app/screens/createGroupScreen.dart';
import 'package:chat_app/screens/welcomePage.dart';
import 'package:chat_app/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../screens/authScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightThemeData(context),
      routes: {
        AuthScreen.routeName: (context) => AuthScreen(),
        CreateGroupScreen.routeName: (context) => CreateGroupScreen(),
        GroupInbox.routeName: (context) => GroupInbox(),
      },
      onGenerateRoute: (settings) {
        // ignore: avoid_print
        print(settings.arguments);
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => WelcomePage(),
        );
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          } else {
            return WelcomePage();
          }
        },
      ),
    );
  }
}
