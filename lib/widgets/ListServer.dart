import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/models_api/Pet.dart';

class ListServer extends StatefulWidget {
  @override
  _ListServerState createState() => _ListServerState();
}

class _ListServerState extends State<ListServer> {

  List<Pet> _pets = [];

  Future<Null> _getPets () async {
    final response = await http.get(Uri.https('pets.memoadian.com', '/api/pets'));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      Iterable list = result['data'];

      setState(() {
        _pets = list.map((model) => Pet.fromJson(model)).toList();
      });
    } else {
      throw Exception("Fallo al conectar al servidor");
    }
  }

  @override
  void initState() {
    super.initState();
    _getPets();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _pets.length,
      itemBuilder: _petsBuilder,
    );
  }

  Widget _petsBuilder (BuildContext context, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 5,
        ),
        Card(
          child: ListTile(
            title: Text(_pets[index].name),
            subtitle: Text("Edad: ${_pets[index].age} años"),
            leading: Column(
              children: [
                Padding(padding: EdgeInsets.all(0)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(_pets[index].image, height: 50, width: 50,),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'edit', arguments: {"id": _pets[index].id})
                  }
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteAlert(context, index, _pets[index].id)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future deleteAlert (BuildContext context, int position, int id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("Esta acción no puede deshacerse"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () => _deletePet(context, position, id),
              child: Text("Eliminar")
            ),
          ],
        );
      }
    );
  }

  void _deletePet (BuildContext context, int position, int id) async {
    String url = "https://pets.memoadian.com/api/pets/$id";

    return http.delete(Uri.parse(url))
    .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        print(response.body);

        throw Exception("Error al consumir servicio");
      }

      setState(() {
        _pets.removeAt(position);
      });

      Navigator.pop(context);
    });
  }
}