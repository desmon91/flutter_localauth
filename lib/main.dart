import 'package:flutter/material.dart';
import 'package:flutter_localauth/HomePage.dart';
import 'package:flutter_localauth/LoginPage.dart';
import 'package:flutter_localauth/SignupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Local Auth",
      // this will set the initial route to login page
      // so every time we open the app it will alway go to this route first
      initialRoute: "/",
      // this will map all the routes on the app
      // so we can navigate to that route using the route keys: "/", "/signup", "/home"
      routes: <String, WidgetBuilder>{
        "/": (context) => LoginPage(),
        "/signup": (context) => SignupPage(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
