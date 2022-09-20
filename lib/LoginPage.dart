import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  Object userAccount = {};
  //hide the password by default
  bool _hidePassword = true;
  //initial value of the account
  Map<String, String> account = {"email": "", "password": ""};

  //this will handle if the password can be seen or not
  _handleHidePassword() {
    setState(() {
      _hidePassword ? _hidePassword = false : _hidePassword = true;
    });
  }

  //this will set the account data from the input form
  _handleName(text) {
    setState(() {
      account["name"] = text;
    });
  }

  _handleEmail(text) {
    setState(() {
      account["email"] = text;
    });
  }

  _handlePassword(text) {
    setState(() {
      account["password"] = text;
    });
  }

  // this will check if the current user registered or not
  Future<bool> _getUser() async {
    final users = await SharedPreferences.getInstance();
    var isUser = await users.getString(account["email"]!);
    if (isUser == null) {
      return false;
    } else {
      final user = jsonDecode(isUser);
      if (user["email"] == account["email"] &&
          user["password"] == account["password"]) {
        setState(() {
          userAccount = user;
        });
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 100),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 100),
                    alignment: Alignment.center,
                    child: Text(
                      "Auth Login Page",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: TextFormField(
                      onChanged: _handleEmail,
                      decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          hintText: "Enter your email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: TextFormField(
                      onChanged: _handlePassword,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          hintText: "Enter your password",
                          suffixIcon: IconButton(
                              tooltip: "Show Password",
                              onPressed: _handleHidePassword,
                              icon: Icon(Icons.remove_red_eye))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password?"),
                      )),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(double.maxFinite, 0)),
                          onPressed: () {
                            //this will show an error if the user not exist or wrong credentials
                            if (_formKey.currentState!.validate()) {
                              _getUser().then((value) {
                                if (!value) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        // Retrieve the text that the user has entered by using the
                                        // TextEditingController.
                                        title: Text("Wrong email or password!"),
                                        titleTextStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        iconColor: Colors.red,
                                        icon: Icon(Icons.error),
                                        content: Text(
                                          "Please check your input or signup if you don't have an account",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 16),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  fixedSize: Size(
                                                      double.maxFinite, 0)),
                                              onPressed: (() {
                                                Navigator.of(context).pop();
                                              }),
                                              child: Text("OK"))
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.of(context).popAndPushNamed("/home",
                                      arguments: userAccount);
                                }
                              });
                            }
                          },
                          child: Text("Signin"))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                            onPressed: (() {
                              Navigator.pushReplacementNamed(
                                  context, "/signup");
                            }),
                            child: Text("Signup"))
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
