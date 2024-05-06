import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/chat_room_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, this.toggle}) : super(key: key);
  final Function? toggle;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  signMeIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) async {
        if (value != null) {
          setState(() {
            isLoading = false;
          });
          QuerySnapshot querySnapshot =
              await databaseMethods.getUserByUserEmail(emailController.text);
          HelperFunctions.saveUserLoggedSharedPreferences(true);
          HelperFunctions.saveUserEmailSharedPreferences(
              (querySnapshot.docs[0].data() as Map<String, dynamic>)['email'] ??
                  '');
          HelperFunctions.saveUserNameSharedPreferences((querySnapshot.docs[0]
                  .data() as Map<String, dynamic>)['username'] ??
              '');

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatRoomScreen(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val ?? '')
                        ? null
                        : "Enter correct email";
                  },
                  controller: emailController,
                  style: simpleTextFieldStyle(),
                  decoration: textFieldInputDecoration('email', isLogin: true)),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                  validator: (val) {
                    return val!.length < 6
                        ? "Enter Password 6+ characters"
                        : null;
                  },
                  controller: passwordController,
                  style: simpleTextFieldStyle(),
                  obscureText: true,
                  decoration:
                      textFieldInputDecoration('password', isLogin: true)),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    authMethods.resetPass('email');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: simpleTextFieldStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    signMeIn();
                  },
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width / 2, 45)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: isLoading == true
                      ? const CircularProgressIndicator()
                      : const Text('Login')),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have account? ',
                    style: simpleTextFieldStyle(color: Colors.blue.shade800),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.toggle?.call();
                    },
                    child: Text(
                      'Register now',
                      style: simpleTextFieldStyle(
                          underLine: true, color: Colors.blue.shade800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
