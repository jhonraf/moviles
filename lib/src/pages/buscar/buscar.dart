import 'package:flutter/material.dart';

class BuscarPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar"),
        backgroundColor: Colors.blue,
      ),
      body: Text("Buscar Page",textScaleFactor: 1.5),
    );
  }
}