// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../providers/messageProvider.dart';
import '../providers/stickerProvider.dart';
import '../providers/userGroupProvider.dart';
import '../providers/userProvider.dart';
import '../screens/userInfoScreen.dart';
import '../screens/groupSettingScreen.dart';
import '../screens/groupInfoScreen.dart';
import '../screens/archivedScreen.dart';
import '../screens/InboxScreen.dart';
import '../screens/chatScreen.dart';
import '../screens/createGroupScreen.dart';
import '../screens/welcomePage.dart';
import '../theme.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StickerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserGroupProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightThemeData(context),
        routes: {
          AuthScreen.routeName: (context) => AuthScreen(),
          CreateGroupScreen.routeName: (context) => CreateGroupScreen(),
          GroupInbox.routeName: (context) => GroupInbox(),
          ChatScreen.routeName: (context) => ChatScreen(),
          ArchivedScreen.routeName: (context) => ArchivedScreen(),
          GroupInfoScreen.routeName: (context) => GroupInfoScreen(),
          GroupSettingsScreen.routeName: (context) => GroupSettingsScreen(),
        },
        onGenerateRoute: (settings) {
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
      ),
    );
  }
}
