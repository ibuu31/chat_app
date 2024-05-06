import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/view/chat_room_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.toggle}) : super(key: key);
  final Function? toggle;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  signMeUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> userMap = {
        'username': usernameController.text,
        'email': emailController.text,
      };
      HelperFunctions.saveUserLoggedSharedPreferences(true);
      HelperFunctions.saveUserNameSharedPreferences(usernameController.text);
      HelperFunctions.saveUserEmailSharedPreferences(emailController.text);

      authMethods
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        databaseMethods.uploadUserInfo(userMap);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatRoomScreen(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Form(
        key: _formKey,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                          validator: (value) {
                            return (value!.isEmpty || value.length > 2)
                                ? 'Please provide proper username'
                                : null;
                          },
                          controller: usernameController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration('username',
                              isLogin: true)),
                      const SizedBox(
                        height: 15,
                      ),
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
                          decoration:
                              textFieldInputDecoration('email', isLogin: true)),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val!.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          controller: passwordController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration('password',
                              isLogin: true)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            signMeUp();
                          },
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width / 2, 45)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          child: isLoading == true
                              ? const CircularProgressIndicator()
                              : const Text('Register')),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account? ',
                            style: simpleTextFieldStyle(
                                color: Colors.blue.shade800),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.toggle?.call();
                            },
                            child: Text(
                              'Sign-in now',
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
      ),
    );
  }
}
