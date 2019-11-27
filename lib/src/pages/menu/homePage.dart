import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:control_classroom/src/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:control_classroom/main.dart';
import 'package:control_classroom/src/pages/login/loginPage.dart';
import 'package:control_classroom/src/pages/inicio/inicio.dart';
import 'package:control_classroom/src/pages/curso/curso.dart';
import 'package:control_classroom/src/pages/notificacion/notificacion.dart';
import 'package:control_classroom/src/pages/cerrar/cerrar.dart';
import 'package:control_classroom/src/pages/buscar/buscar.dart';

class HomePage extends StatefulWidget {
  @override
  final DocumentSnapshot user;
  HomePage(
    this.user
  );
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  
  final InicioPage _inicioP = InicioPage();
  final CursoPage _cursoP = new CursoPage();
  final BuscarPage _buscarP = new BuscarPage();
  final NotificacionPage _notificacionP = new NotificacionPage();
  final CerrarPage _cerrarP = new CerrarPage();

  Widget _showPage = new InicioPage();

  Widget _pageChooser(int page){
    switch(page){
      case 0:
        return _inicioP;
        break;
      case 1:
       return _cursoP;
       break;
      case 2:
       return _buscarP;
       break;
      case 3:
       return _notificacionP;
       break;
      case 4:
       return _cerrarP;
       break;
      default:
      return new Container(
        child: new Center(
          child: new Text(
            'Pagina no encontrada',
            style: new TextStyle(fontSize: 30)
          ),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context){

    return Scaffold(
    bottomNavigationBar: BottomNavigationBar(
        items: [
          new BottomNavigationBarItem( 
            icon: new Icon(Icons.home, size: 30),
            title: new Text("Inicio",)
          ),
          new BottomNavigationBarItem( 
            icon: new Icon(Icons.book, size: 30),
            title: new Text("Cursos",)
          ),
           new BottomNavigationBarItem( 
            icon: new Icon(Icons.search,size: 30),
            title: new Text("Buscar",)
          ),
          new BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget>[
                new Icon(Icons.notifications, size: 30),
                new Positioned(
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: new Text(
                      '$counter',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            title: Text('Notifications'),
          ),
           new BottomNavigationBarItem( 
            icon: new Icon(Icons.power_settings_new, size: 30),
            title: new Text("Salir",)
          ),

        ],

        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        
        onTap: (int tappedIndex){
          setState(() {
            _showPage = _pageChooser(tappedIndex);
          });
        },
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _showPage,
        ),
      ),
    );
  }
}

