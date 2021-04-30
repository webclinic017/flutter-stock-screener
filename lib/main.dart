import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Album>> futureAlbums;

  // fetch List of Albums
  Future<List<Album>> fetchAlbums() async {
    List<Album> albums = [];

    final res =
        await http.get(Uri.https('jsonplaceholder.typicode.com', '/albums'));

    if (res.statusCode == 200) {
      // convert response to list so that we can loop through it
      var data = jsonDecode(res.body) as List;

      for (var i = 0; i < data.length; i++) {
        albums.add(
          new Album.fromJson(data, i),
        );
      }
    }

    return albums;
  }

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Album>>(
        future: futureAlbums,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var album = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        leading: Text(album.id.toString()),
                        title: Text(album.title),
                        subtitle: Text(album.userId.toString()),
                      ),
                    );
                  },
                )
              : CircularProgressIndicator();
        },
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(List<dynamic> json, int index) => Album(
        userId: json[index]['userId'],
        id: json[index]['id'],
        title: json[index]['title'],
      );
}
