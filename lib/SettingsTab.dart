import 'package:flutter/material.dart';

// This contains the settings tab screen from the bottom nav bar
Widget settingsTab(context, userAccount) {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 200),
      child: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              userAccount["email"],
              style: TextStyle(fontSize: 24),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              userAccount["name"],
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 200, 40, 10),
            child: ElevatedButton(
                onPressed: () {
                  // return to the login screen to signout
                  Navigator.of(context).popAndPushNamed("/");
                },
                child: Text("Sign Out")),
          )
        ],
      ));
}
