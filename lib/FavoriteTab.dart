import 'package:flutter/material.dart';
import 'package:flutter_localauth/DetailsPage.dart';

// This contains the favorite tab screen from the bottom nav bar
Widget favoriteTab(context, favoriteList) {
  final List data = favoriteList.toList();
  return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]["name"]),
            subtitle: Text(data[index]["email"]),
            onTap: () {
              // when tapped or pressed it will go to independent route of details
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Details(data: data[index])),
              );
            },
          );
        },
      ));
}
