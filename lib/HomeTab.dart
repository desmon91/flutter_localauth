import 'package:flutter/material.dart';
import 'package:flutter_localauth/DetailsPage.dart';

Widget homeTab(context, data, favoriteList, handleFavorite) {
  return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          // favoriteList.contains is not working because the hashcode is different
          // when we load the data from shared preference
          // it create different hashcode from the data that is loaded from json
          // so we are using favoriteList.any instead to return a boolean value
          final alreadySaved =
              favoriteList.any((e) => e["id"] == data[index]["id"]);
          return ListTile(
            title: Text(data[index]["name"]),
            subtitle: Text(data[index]["email"]),
            trailing: IconButton(
                onPressed: () => handleFavorite(alreadySaved, data[index]),
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                )),
            onTap: () {
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
