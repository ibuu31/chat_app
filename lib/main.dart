import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/view/chat_room_screen.dart';
import 'package:chat_app/view/search.dart';
import 'package:chat_app/view/sigin_screen.dart';
import 'package:chat_app/view/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// todo colors constants
/// todo make primary color light
/// todo search icon on appbar
/// todo new chat floating button
/// todo chat room screen ui change
/// todo space on bottom of conversation screen
/// todo name of the other person on conversation screen
/// todo send message on tapping enter
/// todo on tapping keyboard the screen should float up
/// todo outline border on login textfields
/// todo change gesture detector to button
/// todo remove google login button
/// todo make login button rectangle
/// todo remove forget password button or add feature of it.
/// todo
/// todo
/// todo
/// todo
/// todo

void main() async {
  // the below line is important before initializing the firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isUserLoggedIn;
  checkUserLoggedIn() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isUserLoggedIn = value ?? false;
      });

      print(isUserLoggedIn);
    });
  }

  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff145C9E),
          scaffoldBackgroundColor: Color(0xff1F1F1F)),
      debugShowCheckedModeBanner: false,
      home: isUserLoggedIn == null
          ? const CircularProgressIndicator()
          : isUserLoggedIn == true
              ? ChatRoomScreen()
              : Authenticate(),
    );
  }
}
