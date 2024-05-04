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
        databaseMethods.uploadUserInfo(userMap);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(),
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
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 24),
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
                          decoration: textFieldInputDecoration('username')),
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
                          decoration: textFieldInputDecoration('email')),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val!.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          controller: passwordController,
                          style: simpleTextFieldStyle(),
                          decoration: textFieldInputDecoration('password')),
                      SizedBox(height: 8),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Text(
                            'Forgot Password?',
                            style: simpleTextFieldStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC),
                              ])),
                          child: Text(
                            'Sign up',
                            style: simpleTextFieldStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Sign up with Google',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account? ',
                            style: simpleTextFieldStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.toggle?.call();
                            },
                            child: Text(
                              'Sign-in now',
                              style: simpleTextFieldStyle(underLine: true),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
