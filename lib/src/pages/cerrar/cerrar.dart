import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_classroom/src/services/AuthService.dart';
import 'package:control_classroom/src/pages/login/loginpage.dart';

class CerrarPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Salir"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          FloatingActionButton.extended(
          onPressed: () async{
            await Provider.of<AuthService>(context).salir();
            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage())); 
          },
          label: Text('Cerrar Sesión'),
          icon: Icon(Icons.exit_to_app),
          backgroundColor: Colors.blue,
        ),])
    ),
    );
  }
}