import 'package:control_classroom/src/actividades/actividad.dart';
import 'package:control_classroom/src/actividades/califica.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class lista_cursos2 extends StatelessWidget {
  String idmat, nombre_materia,docid;
  lista_cursos2(this.idmat,this.nombre_materia,this.docid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: new Text(
          "Curso",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _fondoApp(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _texto(),
                _menuNav(context)
              ]
            ),
          )
        ],
      ),
    );
  }
  
  Widget _fondoApp(){

    final container1 = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors : [
            Color(0xFF90CAF9),
            Color(0xFF64B5F6),
          ]
        ),
      ),      
    );

    final container2 = Transform.rotate(
      angle: -pi/5.0,
      child: Container(
        width: 340,
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors:[
              Color(0xFFCE93D8),
              Color(0xFFBA68C8)
            ] 
          )
        ),
      )
    ); 
    
    return Stack(
      children: <Widget>[
        container1,
        Positioned(
          top: -100,
          child: container2
        )
      ],
    );
  }

  Widget _texto(){
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(this.nombre_materia, style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget _menuNav(BuildContext context){
    return Table(
      children: [
        TableRow(
          children: [
            GestureDetector(
              child: _crearBoton(Colors.blue, Icons.check,'Evaluación',context),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => PantallaCalifica(this.idmat,this.nombre_materia,this.docid)),);
              },
            ),
            GestureDetector(
              child: _crearBoton(Colors.green, Icons.person,'Alumnos',context),
              onTap: (){
                print("tapped"); //al darle tap a una imagen de la lista de alumnos
                  Navigator.push(context,MaterialPageRoute(builder: (context) => PantallaAlumnos(this.idmat,this.nombre_materia,this.docid)),);
              },
            )
          ]
        ),
        TableRow(
          children: [
            GestureDetector(
              child: _crearBoton(Colors.purple, Icons.check,'Actividades',context),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => PantallaActividad(this.idmat,this.nombre_materia,this.docid)),);
              },
            ),
            GestureDetector(
              child: _crearBoton(Colors.purple, Icons.check,'Evaluación',context),
              onTap: (){
                //Rutas de las nuevas vistas
              },
            )
          ]
        ),
        TableRow(
          children: [
            GestureDetector(
              child: _crearBoton(Colors.yellow, Icons.check,'Evaluación',context),
              onTap: (){
                //Rutas de las nuevas vistas
              },
            ),
            GestureDetector(
              child: _crearBoton(Colors.yellow, Icons.check,'Evaluación',context),
              onTap: (){
                //Rutas de las nuevas vistas
              },
            )
          ]
        ),
      ],
    );
  }

  Widget _crearBoton(Color color, IconData icon, String texto, BuildContext context){
    return Container(
      height: 180,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(62, 66, 107, 0.7),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(height: 4.0,),
          CircleAvatar(
            backgroundColor: color,
            radius: 35,
            child: Icon(icon, color: Colors.white, size: 18.0,),
          ),
          Text(texto, style: TextStyle(color: color)),
          SizedBox(height: 4.0),
        ],
      ),
    );
  }
}
//------------------Pantalla de matriculas de alumnos----------------------
enum ConfirmAction { CANCEL, ACCEPT }

class PantallaAlumnos extends StatelessWidget {
  String idmat, nombmat,docid;
  PantallaAlumnos(this.idmat,this.nombmat,this.docid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nombmat),
        backgroundColor: Colors.blue, 
      ),
      body: ListPage2(this.idmat,this.docid),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FutureBuilder<ConfirmAction>(
                    future: addAlumnoDialog(context),
                    builder: (context, snapshot){
                      print('In Builder');
                    }
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),        
      ),
    );
  }

    //---------------Dialogo Insertar Alumnos-------------------------------
 
 Future<ConfirmAction> addAlumnoDialog(BuildContext context) async {
  
  String Matricula='';
  final matricula = TextEditingController();  
  final _formKey = GlobalKey<FormState>();  
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
      child: AlertDialog(
        title: Text('Registrar Alumno'),         
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,             
              child: new Form(
                key: _formKey,           
                  child: Column(     
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,         
                    children: <Widget>[          
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {
                            return 'Matricula es Requerida';
                          }else{        
                            if(isUnsignedIntegers(value)){
                              if(value.length==9){
                                return null;
                              }else{
                                return 'Longitud de Matricula debe ser 9';
                              }                    
                            }else{                              
                              return 'La matricula debe de ser numerico';
                            }
                          }                                               
                        },
                        onSaved: (String val) {
                          Matricula = val;
                        },
                        controller: matricula,
                        autofocus: true,              
                        decoration: InputDecoration(      
                          icon: Icon(Icons.credit_card),          
                          labelText: 'Matricula', hintText: '201501589'
                        )                                                                                       
                      ),
                    ]     
                  )
              ),        
            ),    
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCELAR'),
            onPressed: () {                         
              Navigator.of(context).pop(ConfirmAction.CANCEL);              
            },
          ),
          FlatButton(
            child: const Text('ACEPTAR'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                print('Form valido');
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                print(Matricula);
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                //Si la informacion ha sido validada entonces Procedemos a insertar
                addAlumno(Matricula);                
                Navigator.of(context).pop(ConfirmAction.ACCEPT);   
              }else{
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                print('Datos en el Form NO validos');
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
              }
            },
          )
        ],
      ));
    },
  );
}
//Validador
  bool isUnsignedIntegers(String str) {
      Pattern pattern = r'^[0-9]*$';
      RegExp regex = new RegExp(pattern);      
        if(regex.hasMatch(str)){        
          return true;
        }else{          
          return false;
        }                  
    }
//Funcion que añade alumno
  void addAlumno(String Matricula){
      Firestore.instance.runTransaction((transaction) async {
          await transaction.set(Firestore.instance.collection('cursos').document(docid).collection('alumnos').document(), {
            'matricula': Matricula,
          });
        });
    } 
}

class ListPage2 extends StatefulWidget {
  String idmat;
  String docid;
  ListPage2(this.idmat,this.docid);
  @override
  _ListPageState2 createState() => _ListPageState2(this.idmat,this.docid);
}

class _ListPageState2 extends State<ListPage2> {  
  String idmat;
  String docid;
  _ListPageState2(this.idmat,this.docid);
  
  @override

  Widget build(BuildContext context) {
  print(idmat);
  return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cursos').document(docid).collection("alumnos").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {          
           return Center(             
              child:  new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[       
                new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),                   
                Text('  Cargando...',style: TextStyle(fontWeight: FontWeight.bold) ) 
                ]));
        }
        return new ListView(children: getAlumnos(snapshot));        
      }
    );
  }

getAlumnos(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => GestureDetector(
          onHorizontalDragUpdate:(a){deleteAlumnoDialog(docid.toString(),doc["matricula"].toString(),doc.documentID);
                  },
          child:
          new Card( child : 
          new ListTile(
            leading: FlutterLogo(),            
            //-----------------------------------------------------------
            title: new Text(doc["matricula"].toString()),
            //Visualizar matricula alumnos
            //-----------------------------------------------------------                      
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed:(){
                    deleteAlumnoDialog(docid.toString(),doc["matricula"].toString(),doc.documentID);
                  }, 
                ) 
              ]
            ),
          ),
        )
      )
      ).toList();
  }

  Future<void> deleteAlumnoDialog(String id,String matricula,String id2) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.blue),
            child: AlertDialog(
            title: Text(
              'Eliminar Alumno',
              style: TextStyle(
                color: Colors.white,                                   
              ),              
              textAlign: TextAlign.center,
            ),                        
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical, 
              child: Column(                
                children: <Widget>[
                  Text("¿Esta seguro que desea eliminar este alumno ?",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),
                  Text('\n' + "Nombre: "+ matricula , style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),                                              
                ],                                                                                                 
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                child: const Text('CANCELAR'),
                onPressed: () {                         
                  Navigator.of(context).pop(ConfirmAction.CANCEL);   
                  print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                  print('Cancelar Eliminacion');
                  print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');           
                },
              ),
              FlatButton(
                color: Colors.white,
                child: const Text('ACEPTAR'),
                onPressed: () {
                  print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                  print('Preparando para eliminar documento');
                  print(id);
                  print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                  //AQUI FUNC ELIMINAR
                  deleteAlumno(id,matricula,id2);
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              )
            ],      
         )
      );
    },
  );}

  //Función que elimina a un usuario de la BD
 void deleteAlumno(String id, String matricula,String id2){   
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance.collection('cursos').document(id).collection("alumnos").document(id2),);
    });
  }

}
