import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:my_first_app/models_api/Pet.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class PetsList extends StatefulWidget {
  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> {

  List<Pet> _pets = [];

  FRefreshController _controller = FRefreshController();

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
    return FRefresh(
      controller: _controller,
      header: CircularProgressIndicator(),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _pets.length,
        itemBuilder: _buildPets,
      ),
      onRefresh: () {
        _getPets();
        _controller.finishRefresh();
      },
    );
  }

  Widget _buildPets (BuildContext context, int index) {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(_pets[index].image),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Text(_pets[index].name, style: TextStyle(fontSize: 18),),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.pushNamed(context, 'detail', arguments: {'id': _pets[index].id})
              },
              child: Text("Ver")
            ),
          ],
        ),
      ),
    );
  }
}