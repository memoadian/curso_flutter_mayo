import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/const/Values.dart';
import 'package:my_first_app/models/PetKeyValues.dart';
import 'package:my_first_app/models_api/Pet.dart';
import 'package:ndialog/ndialog.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'package:http/http.dart' as http;

class AddPetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir macscota"),
      ),
      body: FormAddPetPage(),
    );
  }
}

class FormAddPetPage extends StatefulWidget {
  @override
  _FormAddPetPageState createState() => _FormAddPetPageState();
}

class _FormAddPetPageState extends State<FormAddPetPage> {
  // Variables de formulario

  List<PetKeyValue> _types = [
    PetKeyValue(id: '1', value: 'Perrito'),
    PetKeyValue(id: '2', value: 'Gatito'),
  ];

  String _selectType = "Por favor elige";
  String _selectTypeId = "";

  bool _rescue = false;

  PickedFile _imageFile;

  GlobalKey<FormState> _formKey = GlobalKey();

  ProgressDialog dialog;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Nombre",
                  labelText: "Nombre",
                  icon: Icon(Icons.pets)
                ),
                maxLength: 32,
                validator: Validators.compose([
                  Validators.required('El nombre es obligatorio'),
                ]),
              ),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Descripción",
                  labelText: "Descripción",
                  icon: Icon(Icons.book)
                ),
                validator: Validators.compose([
                  Validators.required('Descripición es obligatoria'),
                ]),
              ),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Edad",
                  labelText: "Edad",
                  icon: Icon(Icons.date_range)
                ),
                validator: Validators.compose([
                  Validators.required('La edad es obligatoria'),
                  Validators.patternRegExp(RegExp(r'(^[0-9]+$)'), "edad no válida")
                ]),
              ),

              /** DROPDOWN */

              DropdownButton<PetKeyValue>(
                hint: Text(_selectType),
                isExpanded: true,
                items: _types.map((PetKeyValue value) {
                  return DropdownMenuItem<PetKeyValue>(
                    value: value,
                    child: Text(value.value)
                  );
                }).toList(),
                onChanged: (PetKeyValue value) => {
                  setState(() {
                    _selectTypeId = value.id;
                    _selectType = value.value;
                  })
                },
              ),

              /** SWITCH */
              SwitchListTile(
                title: Text(Values.resue, style: TextStyle(fontSize: Values.font16),),
                value: _rescue,
                onChanged: (value) => {
                  setState(() {
                    _rescue = value;
                  })
                }
              ),

              /** SELECTOR DE IMAGEN */
              _chooseImage(context),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _validateForm(),
                  icon: Icon(Icons.send),
                  label: Text("Enviar"),
                ),
              ),
            ],
          )
        )
      ),
    );
  }

  Widget _imageDefault () {
    return FutureBuilder<File>(
      builder: (context, snapshot) {
        return Container (
          padding: EdgeInsets.all(20),
          child: _imageFile == null
                ? Text("Selecciona una imagen", style: TextStyle(fontSize: Values.font14),)
                : Image.file(File(_imageFile.path), width: 300, height: 150,),
        );
      }
    );
  }

  void _pickImage (ImageSource source) async {
    _imageFile = await ImagePicker.platform.pickImage(source: source);

    setState(() {
      _imageFile = _imageFile;
    });
  }

  Widget _chooseImage(BuildContext context) {
    return Center (
      child: Column(
        children: <Widget> [
          _imageDefault(),
          ElevatedButton(
            child: Text("Escoger Imagen"),
            onPressed: () => {
              _pickImage(ImageSource.camera)
            },
          )
        ]
      ),
    );
  }

  void _validateForm () {
    if(_formKey.currentState.validate()) {
      dialog = ProgressDialog(context, 
        message:Text("Enviando"), 
        title:Text("Mandando datos al servidor")
      );

      dialog.show();

      Pet newPet = Pet(
        name: nameController.text,
        desc: descriptionController.text,
        age: (ageController.text != "") ? int.parse(ageController.text) : 0,
        image: _getImage(),
        typeId: int.parse(_selectTypeId),
        statusId: (_rescue) ? 2 : 1
      );

      _createPost("https://pets.memoadian.com/api/pets/", newPet.toMap());
    }
  }

  // Convertir imagen en base 64
  String _getImage() {
    if (_imageFile == null) return "";

    String base64Image = base64Encode(File(_imageFile.path).readAsBytesSync());
    return base64Image;
  }

  void _createPost (String url, Map body) async {
    return http.post(Uri.parse(url), body: body)
        .then((http.Response response) {
          dialog.dismiss();
          final int statusCode = response.statusCode;

          if (statusCode < 200 || statusCode > 400) {
            throw Exception("Error al mandar datos "+response.body);
          }

          Navigator.pushNamed(context, '/');
        }).onError((error, stackTrace){
          dialog.dismiss();
        });
  }

}