import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/requests_http.dart';
import 'package:flutter_application_1/views/favorites.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> favorites = [];
  TextEditingController filterController = TextEditingController();

  void favorite(String code) {
    if (!favorites.contains(code)) {
      setState(() => favorites.add(code));
    } else {
      setState(() => favorites.remove(code));
    }
  }

  void search(String filtro) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Moedas'),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Favorites(favorites: favorites)),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Favoritos',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: TextField(
                  controller: filterController,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    text = text.toUpperCase();
                    filterController.value = filterController.value.copyWith(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                    );
                    search(text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: getMoedas(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<String> moedas = snapshot.data.keys.toList();
            List<String> filtro = moedas.where((moeda) => moeda.contains(filterController.text)).toList();
            return ListView.builder(
              itemCount: filtro.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onLongPress: () {
                      favorite('${snapshot.data[filtro[index]]['code']}-${snapshot.data[filtro[index]]['codein']}');
                    },
                    child: Card(
                      elevation: 10,
                      color: Colors.yellow,
                      child: Column(
                        children: [
                          Text('${snapshot.data[filtro[index]]['code']}'),
                          Text('${snapshot.data[filtro[index]]['name']}'),
                          Text('Valor: R\$${snapshot.data[filtro[index]]['bid']}'),
                          Icon(favorites.contains('${snapshot.data[filtro[index]]['code']}-${snapshot.data[filtro[index]]['codein']}')
                              ? Icons.star
                              : Icons.star_border),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
