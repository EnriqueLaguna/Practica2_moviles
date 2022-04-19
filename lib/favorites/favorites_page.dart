import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      backgroundColor: Color.fromARGB(255, 70, 70, 70),
      body: Center(
        child: Container(
          child: Text("Favoritos"),
        ),
      ),
    );
  }
}