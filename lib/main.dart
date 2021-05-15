import 'package:flutter/material.dart';
import 'package:my_first_app/routes/AddPetPage.dart';
import 'package:my_first_app/routes/AdminPage.dart';
import 'package:my_first_app/routes/DetailPetPage.dart';
import 'package:my_first_app/routes/EditPetPage.dart';
import 'package:my_first_app/routes/HomePage.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isOrange = false;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadColor();
  }

  void _loadColor () async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _isOrange = (prefs.getBool('orange') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        //'/': (context) => HomePage(),
        'admin': (context) => AdminPage(),
        'detail': (context) => DetailPetPage(),
        'edit': (context) => EditPetPage(),
        'add': (context) => AddPetPage(),
      },
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: (_isOrange) ? Colors.orange : Colors.green,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Mi primera app"),
              actions: <Widget>[
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () => {
                        Scaffold.of(context).openEndDrawer()
                      });
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text("Guillermo Canales", style: TextStyle(color: Colors.white),),
                    accountEmail: Text("memoadian@gmail.com", style: TextStyle(color: Colors.white),),
                    currentAccountPicture: CircleAvatar(
                      ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('https://image.winudf.com/v2/image/Y29tLkNoaWVmV2FsbHBhcGVycy5GbGF0MDhfc2NyZWVuc2hvdHNfMF9hN2M2YjM3MQ/screen-0.jpg?fakeurl=1&type=.jpg'),
                        //Usar AssetImage con assets
                      )
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Inicio"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () => {
                      Navigator.pop(context)
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pets),
                    title: Text("Administrar"),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () => {
                      Navigator.pushNamed(context, 'admin')
                    },
                  ),
                ],
              ),
            ),
            endDrawer: Drawer(
              child: Column(
                children: <Widget>[
                  AppBar(
                    automaticallyImplyLeading: false,
                    title: Text("Configurar"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context)
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SwitchListTile(
                        title: Text("Tema naranja"),
                        value: _isOrange,
                        onChanged: (value) => {
                          setState(() {
                            _isOrange = value;
                            prefs.setBool('orange', value);
                            //prefs.remove('orange'); limpiar key
                            //prefs.clear(); remover todas las preferencias
                          })
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: HomePage(),
          );
        }
      ),
    );
  }
}