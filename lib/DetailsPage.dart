import 'package:flutter/material.dart';

// This contains a detailed data screen
class Details extends StatelessWidget {
  Details({super.key, required this.data});

  final data;
  final textLook = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: ListView.builder(
          itemCount: data.keys.length,
          itemBuilder: ((context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Text(data.keys.elementAt(index), style: textLook),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.topLeft,
                  ),
                  flex: 1,
                ),
                Expanded(
                    child: Container(
                      child: Text(
                        data[data.keys.elementAt(index)].toString(),
                        style: textLook,
                        softWrap: true,
                      ),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.topLeft,
                    ),
                    flex: 3)
              ],
            );
          })),
    );
  }
}
