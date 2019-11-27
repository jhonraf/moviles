import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:control_classroom/src/pages/menu/homePage.dart';
import 'package:control_classroom/src/pages/login/loginPage.dart';
import 'package:control_classroom/src/pages/register/registerPage.dart';
import 'package:provider/provider.dart';
import 'package:control_classroom/src/services/AuthService.dart';
import 'package:control_classroom/src/pages/menu/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        builder: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  DocumentSnapshot user;    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('🌐 Conexion establecida');
            if (snapshot.error != null) { 
             // print("🚫 ERROR");
              //print(snapshot.error.toString());
              //return Text(snapshot.error.toString());
              return LoginPage();
            }else{
            
              if(snapshot.hasData){
                print('🔒 Existe sesion');
                //user=snapshot.data;
                return HomePage(snapshot.data);
              }else{
                print('🔓 No existe sesion');
                return LoginPage();
              }
            }            
            // redirect to the proper page
           // return snapshot.hasData ? HomePage(snapshot.data) : LoginPage();
          } else {
            
              return LoadingCircle();
            
          }
        },
      ),
      routes: <String, WidgetBuilder> {      
        "main" : (BuildContext context) => new MyApp(),  
        "Login" : (BuildContext context) => new LoginPage(),
        "Register" : (BuildContext context) => new RegisterPage(), 
        "Home" : (BuildContext context) => new HomePage(user), 
      }      
    );
  }
}

class LoadingCircle extends StatelessWidget {
  
  @override  
  Widget preloader = Stack(
      alignment: const Alignment(0, 0.7),         
      children: [     
        Container(
          padding: const EdgeInsets.only(top: 10,bottom: 0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,                     
            children: <Widget>[
             
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Image(image: preloaderImage)
                  
                  CircularProgressIndicator()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Cargando ...',style: 
                  TextStyle(
                    fontWeight:FontWeight.bold,
                    color: Colors.black),
                    textAlign: TextAlign.center,
                  )
                ],
              )                            
            ]
          ),
        )
      ],
    );

  Widget build(BuildContext context) {
    return new Scaffold(      
      body: Center(        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: <Widget>[
            preloader
          ]
        )
    )
  );
  } 
}
