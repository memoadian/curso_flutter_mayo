import 'package:flutter/material.dart';
import 'package:my_first_app/models_api/Pet.dart';
import 'package:my_first_app/models_db/Fav.dart';
import 'package:my_first_app/models_db/FavsHelper.dart';

class Favs extends StatefulWidget {
  @override
  _FavsState createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  final dbHelper = FavsHelper();

  List<Fav> _favs = [];

  @override
  void initState() {
    super.initState();
    _getFavs();
  }

  void _getFavs () {
    dbHelper.getAllFavs().then((favs) => {
      setState(() {
        favs.forEach((e) {
          _favs.add(Fav.fromMap(e));
        });
      })
    });
  }

  void _deleteFav (BuildContext context, int id, int position) {
    dbHelper.deleteFav(id).then((fav) => {
      setState(() {
        _favs.removeAt(position);
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _favsBuilder,
      itemCount: _favs.length,
    );
  }

  Widget _favsBuilder (BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Divider(
          height: 15,
        ),
        Card(
          child: ListTile(
            title: Text(_favs[index].name),
            subtitle: Text("Edad: ${_favs[index].age}años"),
            leading: Image.network(_favs[index].image),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => {
                    _deleteFav(context, _favs[index].id, index)
                  }
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}