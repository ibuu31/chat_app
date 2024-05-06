import 'package:chat_app/view/sigin_screen.dart';
import 'package:chat_app/view/signup_screen.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignin = true;
  void toggleView() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignin) {
      return SignInScreen(
        toggle: toggleView,
      );
    }
    return SignUpScreen(
      toggle: toggleView,
    );
  }
}
