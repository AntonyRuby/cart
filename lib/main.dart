import 'dart:convert';

import 'package:cart/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Map<String, String>> loadAssets(context) async {
    final items =
        await DefaultAssetBundle.of(context).loadString('assets/items.json');

    return {'items': items};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: loadAssets(context),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Text("Loading"),
                );
              } else {
                var items = json.decode(snapshot.data["items"].toString());
                return HomePage(items: items);
              }
            }));
  }
}
