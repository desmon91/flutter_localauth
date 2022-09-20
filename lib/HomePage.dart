import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localauth/FavoriteTab.dart';
import 'package:flutter_localauth/HomeTab.dart';
import 'package:flutter_localauth/SettingsTab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBottomNavIndex = 0;
  List data = [];
  // we are using Set instead of list because in Set there is no duplicate value
  Set favoriteList = {};
  bool alreadySaved = false;
  Map<String, dynamic> userAccount = {};

  // this will handle tap or press event on the bottom nav bar
  void _handleBottomNavTap(index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  // this will handle tap or press event on the heart icon
  void handleFavorite(alreadySaved, data) async {
    setState(() {
      if (alreadySaved) {
        // favoriteList.remove is not working because the hashcode is different
        // when we load the data from shared preference
        // it create different hashcode from the data that is loaded from json
        // so we are using favoriteList.where instead to return a value that did not match
        var result = favoriteList.where((e) => e["id"] != data["id"]);
        favoriteList = result.toSet();
      } else {
        favoriteList.add(data);
      }
      // we are storing the favoriteList as List type instead of Set
      // because jsonEncode did not support Set to be converted to json
      userAccount["favoriteList"] = favoriteList.toList();
    });
    final user = await SharedPreferences.getInstance();

    user.setString(userAccount["email"]!, jsonEncode(userAccount));
  }

  Future<void> fetchJsonData() async {
    String response = await rootBundle.loadString("dummy/data.json");
    setState(() {
      // data needed to be parsed first before it can be used
      data = jsonDecode(response);
    });
  }

  @override
  void initState() {
    super.initState();
    //on first load up fetch the data from the json file
    fetchJsonData();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // we are loading the passed argument from the /home route here which is a userAccount data
      userAccount =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (userAccount["favoriteList"] == null ||
          userAccount["favoriteList"].isEmpty) {
        favoriteList = {};
      } else {
        // we are converting the favoriteList to Set so we can use the no duplicate data feature
        favoriteList = userAccount["favoriteList"].toSet();
      }
    });

    // This is a widget list for bottom nav bar
    List<Widget> _bottomNavTab = [
      data.isNotEmpty
          ? homeTab(context, data, favoriteList, handleFavorite)
          : Text("No data"),
      favoriteList.isNotEmpty
          ? favoriteTab(context, favoriteList)
          : Text("No data"),
      settingsTab(context, userAccount)
    ];

    // This is a tab name list
    List<String> _tabName = ["Home", "Favorite", "Settings"];
    return MaterialApp(
      initialRoute: "/",
      home: Scaffold(
        appBar: AppBar(title: Text(_tabName[_currentBottomNavIndex])),
        // builder widget is needed so we can pass the context to each of the bottom nav tab screen
        body: Builder(builder: (context) {
          //the body are being switched by the bottom nav index
          return _bottomNavTab[_currentBottomNavIndex];
        }),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "Favorite"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ],
          currentIndex: _currentBottomNavIndex,
          selectedItemColor: Colors.blueAccent,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(size: 32),
          onTap: _handleBottomNavTap,
        ),
      ),
    );
  }
}
