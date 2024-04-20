import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/services/requests_http.dart';
import 'package:flutter_application_1/views/login.dart';

class Favorites extends StatefulWidget {
  List favorites;

  Favorites({super.key, required this.favorites});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Moedas Favoritas')),
        body: FutureBuilder(
          future: widget.favorites.length > 0 ? getMoedasFavoritas(widget.favorites) : null,
          builder: (favorites, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<String> moedas = snapshot.data != null ? snapshot.data.keys.toList() : [];
              return ListView.builder(
                itemCount: moedas.length,
                itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                            elevation: 10,
                            color: Colors.yellow,
                            child: Column(
                              children: [
                                Text('${snapshot.data[moedas[index]]['code']}'),
                                Text('${snapshot.data[moedas[index]]['name']}'),
                                Text('Valor: R\$${snapshot.data[moedas[index]]['bid']}'),
                              ],
                            )),
                      ),
                    );
                },
              );
            }
          },
        ));
  }
}
