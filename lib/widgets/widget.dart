import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/view/sigin_screen.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context, {bool? showSignOut}) {
  AuthMethods authMethods = AuthMethods();
  return AppBar(
    title: Image.asset(
      'assets/images/logo.png',
      height: 50,
    ),
    actions: [
      showSignOut == true
          ? IconButton(
              onPressed: () {
                HelperFunctions.saveUserLoggedSharedPreferences(false);
                authMethods.signOut().then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Authenticate(),
                      ));
                });
              },
              icon: Icon(Icons.logout))
          : Container()
    ],
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54));
}

TextStyle simpleTextFieldStyle({bool? underLine}) {
  return TextStyle(
      color: Colors.white,
      fontSize: 16,
      decoration: underLine == true ? TextDecoration.underline : null);
}
