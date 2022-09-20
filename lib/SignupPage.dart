import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This contains a page for the user to signup
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  bool _hidePassword = true;
  Map<String, String> account = {"email": "", "name": "", "password": ""};

  _handleHidePassword() {
    setState(() {
      _hidePassword ? _hidePassword = false : _hidePassword = true;
    });
  }

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

  Future<bool> _setUser() async {
    final users = await SharedPreferences.getInstance();
    var isExist = await users.getString(account["email"]!);
    if (isExist == null) {
      users.setString(account["email"]!, jsonEncode(account));
      return false;
    } else {
      return true;
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
                      "Register Page",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: TextFormField(
                      onChanged: _handleName,
                      decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                          hintText: "Enter your name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
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
                      padding: EdgeInsets.fromLTRB(10, 50, 10, 5),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(double.maxFinite, 0)),
                          onPressed: () {
                            //this will show an error if the user already exist
                            if (_formKey.currentState!.validate()) {
                              _setUser().then((value) {
                                if (value) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        // Retrieve the text that the user has entered by using the
                                        // TextEditingController.
                                        title: Text("Email already exist!"),
                                        titleTextStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        iconColor: Colors.red,
                                        icon: Icon(Icons.error),
                                        content: Text(
                                          "Please choose another email",
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
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        // Retrieve the text that the user has entered by using the
                                        // TextEditingController.
                                        title: Text("Registered successfully!"),
                                        titleTextStyle: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                        iconColor: Colors.green,
                                        icon: Icon(Icons.error),
                                        content: Text(
                                          "Now you can use this account to Signin",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  fixedSize: Size(
                                                      double.maxFinite, 0)),
                                              onPressed: (() {
                                                Navigator.of(context)
                                                    .popAndPushNamed("/");
                                              }),
                                              child: Text("OK"))
                                        ],
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                      );
                                    },
                                  );
                                }
                              });
                            }
                          },
                          child: Text("Submit"))),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      alignment: Alignment.center,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue),
                              fixedSize: Size(double.maxFinite, 0)),
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/");
                          },
                          child: Text("Cancel"))),
                ],
              )),
        ),
      ),
    );
  }
}
