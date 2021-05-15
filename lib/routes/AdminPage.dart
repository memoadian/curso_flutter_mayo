import 'package:flutter/material.dart';
import 'package:my_first_app/widgets/ListServer.dart';
import 'package:my_first_app/widgets/Favs.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  Widget build(BuildContext context) {
    return tabs();
  }

  Widget tabs () {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Administrar mascotas"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Favoritos"),
              Tab(text: "Server"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Favs(),
            ListServer()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'add');
          },
        ),
      ),
    );
  }
}