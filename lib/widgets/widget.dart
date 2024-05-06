import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context, {bool? showSignOut}) {
  AuthMethods authMethods = AuthMethods();
  return AppBar(
    elevation: 0,
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
                        builder: (context) => const Authenticate(),
                      ));
                });
              },
              icon: const Icon(Icons.logout))
          : Container()
    ],
  );
}

InputDecoration textFieldInputDecoration(String hintText,
    {bool? searchField, bool? isUnderLineBorder, bool? isLogin}) {
  return InputDecoration(
      contentPadding: const EdgeInsets.all(20),
      fillColor: Colors.blue.shade800.withOpacity(0.5),
      filled: isLogin == true ? true : false,
      focusedBorder: isUnderLineBorder == true
          ? const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))
          : OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: searchField == true
                  ? BorderRadius.circular(30)
                  : const BorderRadius.all(Radius.circular(4.0)),
            ),
      enabledBorder: isUnderLineBorder == true
          ? const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))
          : OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: searchField == true
                  ? BorderRadius.circular(30)
                  : const BorderRadius.all(Radius.circular(4.0)),
            ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white));
}

TextStyle simpleTextFieldStyle(
    {bool? underLine, bool? boldEnabled, Color? color}) {
  return TextStyle(
      color: color ?? Colors.white,
      fontSize: 16,
      fontWeight: boldEnabled == true ? FontWeight.w600 : null,
      decoration: underLine == true ? TextDecoration.underline : null);
}
