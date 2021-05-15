import 'package:flutter/material.dart';

class Favs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Divider(
          height: 15,
        ),
        Card(
          child: ListTile(
            title: Text("Amigo"),
            subtitle: Text("Edad: 0años"),
            leading: Image.asset('assets/image.png'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => {
                    Navigator.pushNamed(context, 'edit')
                  }
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => {}
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}