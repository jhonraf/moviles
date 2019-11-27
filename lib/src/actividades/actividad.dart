import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:dropdownfield/dropdownfield.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class PantallaActividad extends StatelessWidget {
  String idmat, nombmat,docid;
  PantallaActividad(this.idmat,this.nombmat,this.docid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nombmat),
        backgroundColor: Colors.blue, 
      ),
      body: ListPage20(this.idmat,this.docid),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FutureBuilder<ConfirmAction>(
                    future: addActividadDialog(context,this.docid),
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
 
 Future<ConfirmAction> addActividadDialog(BuildContext context,docid) async {
  String docidd=docid;
  String Nombre='',Descripcion='',Criterio='',Fecha_inicio='',Fecha_final=''; 
  List<String> criterios = obtenerCriterios(docidd);
  final format = DateFormat("dd/MM/yyyy");
  const Locale('es');
  final nombre = TextEditingController(); 
  final descripcion = TextEditingController(); 
  final criterio = TextEditingController();   
  final fecha_inicio = TextEditingController();  
  final fecha_final = TextEditingController();  
  final _formKey = GlobalKey<FormState>();  
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
      child: AlertDialog(
        title: Text('Registrar Actividad'),         
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
                            return 'Nombre es Requerido';
                          }else{        
                            
                              if(value.length>4){
                                return null;
                              }else{
                                return 'Longitud de Nombre debe ser al menos de 5';
                              }                                              
                          }                                               
                        },
                        onSaved: (String val) {
                          Nombre = val;
                        },
                        controller: nombre,
                        autofocus: true,              
                        decoration: InputDecoration(      
                          icon: Icon(Icons.credit_card),          
                          labelText: 'Nombre', hintText: 'Nombre de la Actividad'
                        )                                                                                       
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'Descripcion es Requerida';
                          }else{        
                            
                              if(value.length<100){
                                return null;
                              }else{
                                return 'Longitud de Descripcion MAX(100)';
                              }     
                          }                                                                     
                        },
                        onSaved: (String val) {
                          Descripcion = val;
                        },
                        controller: descripcion,
                        autofocus: true,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Descripcion de la actividad', hintText: 'En esta actividad se realizara...'
                        )                                                                                       
                      ),
                      DropDownField(
                                    icon: Icon(Icons.account_circle),
                                    required: true,
                                    hintText: 'Elige un Criterio',
                                    labelText: 'Criterios',
                                    items: criterios,
                                    strict: true,
                                    setter: (dynamic newValue) {
                                      Criterio = newValue;
                                    },
                                    
                                    ),
                      DateTimeField(
                        format: format,
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Fecha Inicio', hintText: 'Fecha inicio'
                        ),
                        onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onSaved: (currentValue) {
                          Fecha_inicio = currentValue.toString();
                        },
                        ),
                        DateTimeField(
                        format: format,
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Fecha Final', hintText: 'Fecha final'
                        ),
                        onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onSaved: (currentValue) {
                          Fecha_final = currentValue.toString();
                        },
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
                print(Nombre);
                print(Descripcion);
                print(Criterio); 
                print(Fecha_inicio);
                print(Fecha_final); 
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                //Si la informacion ha sido validada entonces Procedemos a insertar
                addActividad(Nombre, Descripcion, Criterio,Fecha_inicio,Fecha_final,docidd);                
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

bool isValidName(String str){
      Pattern pattern = r'^[a-zA-Z ]*$';
      RegExp regex = new RegExp(pattern);      
        if(regex.hasMatch(str)){          
          return true;
        }else{          
          return false;
        }      
    }

List<String> obtenerCriterios(String docid){ 
    var lst = new List<String>();   
    final Stream<QuerySnapshot> result = Firestore.instance.collection('cursos').document(docid).collection("criterios").snapshots();
    result.listen((snapshot) {
      snapshot.documents.forEach((doc) {    
          lst.add(doc["nombre"]);
      });
    });
    return lst;
  }

//Funcion que añade alumno
  void addActividad(String nombre,String descripcion, String criterio,String inicio,String fin,String docid){
    final Stream<QuerySnapshot> result = Firestore.instance.collection('cursos').document(docid).collection("alumnos").snapshots();
    result.listen((snapshot) {
      snapshot.documents.forEach((doc) {
      Firestore.instance.runTransaction((transaction) async {
          await transaction.set(Firestore.instance.collection('cursos').document(docid).collection('actividades').document(), {
            'nombre': nombre,
            'descripcion': descripcion,
            'criterio': criterio,
            'fecha_final': fin.substring(0, 10).replaceAll("-", "/"),
            'fecha_inicio': inicio.substring(0, 10).replaceAll("-", "/"),
            'calificacion': "0",
            'alumno': doc["matricula"].toString(),
          });
        });
        
    });});
    } 
}

class ListPage20 extends StatefulWidget {
  String idmat;
  String docid;
  ListPage20(this.idmat,this.docid);
  @override
  _ListPageState20 createState() => _ListPageState20(this.idmat,this.docid);
}

class _ListPageState20 extends State<ListPage20> {  
  String idmat;
  String docid;
  _ListPageState20(this.idmat,this.docid);
  
  @override

  Widget build(BuildContext context) {
  print(idmat);
  return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cursos').document(docid).collection("actividades").snapshots() ,
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
        return new ListView(children: getActividad(snapshot));        
      }
    );
  }

getActividad(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => GestureDetector(
          onHorizontalDragUpdate:(a){deleteAlumnoDialog(docid.toString(),doc["nombre"].toString(),doc.documentID);
                  },
          child:
          new Card( child : 
          new ListTile(
            leading: FlutterLogo(),            
            //-----------------------------------------------------------
            title: new Text(doc["nombre"].toString()),
            subtitle: Column(                
                children: <Widget>[
                  new Text(doc["descripcion"].toString()),
                  new Text(doc["criterio"].toString()),
                  new Text(doc["alumno"].toString()), 
                  new Text(doc["fecha_inicio"].toString() +" - "+ doc["fecha_final"].toString()),                                            
                ],                                                                                                 
              ),
            //Visualizar matricula alumnos
            //-----------------------------------------------------------                      
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(doc["calificacion"].toString(),style: TextStyle(color: Colors.red.withOpacity(1.0))),
                new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed:(){
                    deleteAlumnoDialog(docid.toString(),doc["nombre"].toString(),doc.documentID);
                  }, 
                ) 
              ]
            ),
          ),
        )
      )
      ).toList();
  }

  Future<void> deleteAlumnoDialog(String id,String nombre,String id2) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.blue),
            child: AlertDialog(
            title: Text(
              'Eliminar Actividad',
              style: TextStyle(
                color: Colors.white,                                   
              ),              
              textAlign: TextAlign.center,
            ),                        
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical, 
              child: Column(                
                children: <Widget>[
                  Text("¿Esta seguro que desea eliminar estas actividades ?",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),
                  Text('\n' + "Nombre: "+ nombre , style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),                                              
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
                  deleteAlumno(id,nombre,id2);
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              )
            ],      
         )
      );
    },
  );}

  //Función que elimina a un usuario de la BD
 void deleteAlumno(String id, String nombre,String id2){ 
   final Stream<QuerySnapshot> result = Firestore.instance.collection('cursos').document(docid).collection("actividades").where("nombre", isEqualTo: nombre).snapshots();
    result.listen((snapshot) {
      snapshot.documents.forEach((doc) {  
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance.collection('cursos').document(id).collection("actividades").document(doc.documentID),);
    });
});});
 }
}
