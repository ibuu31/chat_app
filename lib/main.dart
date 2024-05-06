import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/view/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// todo create multiple chats
/// todo upload on github

void main() async {
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
          primarySwatch: MaterialColor(
        Colors.blue.shade800.value,
        <int, Color>{
          50: Color(Colors.blue.shade800.value), //10%
          100: Color(Colors.blue.shade800.value), //20%
          200: Color(Colors.blue.shade800.value), //30%
          // 300: const Color(0xff89392b), //40%
          // 400: const Color(0xff733024), //50%
          500: Color(Colors.blue.shade800.value), //60%
          600: Color(Colors.blue.shade800.value), //70%
          700: Color(Colors.blue.shade800.value), //80%
          // 800: const Color(0xff170907), //90%
          // 900: const Color(0xff000000), //100%
        },
      )
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade800),
          ),
      debugShowCheckedModeBanner: false,
      home: isUserLoggedIn == null
          ? const CircularProgressIndicator()
          : isUserLoggedIn == true
              ? const ChatRoomScreen()
              : const Authenticate(),
    );
  }
}
