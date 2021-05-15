import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_app/models_api/Pet.dart';

class DetailPetPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    Future<Pet> _getPet () async {
      final response = await http.get(Uri.https('pets.memoadian.com', 'api/pets/${args['id']}'));

      print(response.body);

      if (response.statusCode == 200) {
        return Pet.fromJson(json.decode(response.body));
      } else {
        throw Exception("Fallo al conectar a servidor");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getPet(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Image.network(snapshot.data.image),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(snapshot.data.name, style: TextStyle(fontSize: 18),)
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(snapshot.data.desc, style: TextStyle(fontSize: 14))
                        ),
                      ]
                    ),
                  ),
                );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return _loading();
          }
        ),
      ),
    );
  }

  Widget _loading () {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text("Cargando"),
          ),
          CircularProgressIndicator()
          //ProgressIndicator(value: 50, backgroundColor: Color.fromARGB(1, 0, 0, 0),)
        ],
      ),
    );
  }
}