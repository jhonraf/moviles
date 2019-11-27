import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'lista_cursos2.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class CursoPage extends StatefulWidget {
  @override
  _Lista_Cursos createState() => _Lista_Cursos();
}

class _Lista_Cursos extends State<CursoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Cursos"),
      ),
      body: ListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FutureBuilder<ConfirmAction>(
            future: addCourseDialog(context),
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
}

//---------------Dialogo Insertar Cursos-------------------------------
 
 Future<ConfirmAction> addCourseDialog(BuildContext context) async {
  
  String NRC='',Nombre_Materia='',Salon='',Dias='',Hora='';  
  final nrc = TextEditingController(); 
  final nombre_materia = TextEditingController(); 
  final salon = TextEditingController();   
  final dias = TextEditingController();  
  final hora = TextEditingController();  
  final _formKey = GlobalKey<FormState>();  
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
      child: AlertDialog(
        title: Text('Registrar Curso'),         
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
                            return 'NRC es Requerido';
                          }else{        
                            if(isUnsignedIntegers(value)){
                              if(value.length==5){
                                return null;
                              }else{
                                return 'Longitud de NRC debe ser 5';
                              }                    
                            }else{                              
                              return 'El NRC debe de ser numerico';
                            }
                          }                                               
                        },
                        onSaved: (String val) {
                          NRC = val;
                        },
                        controller: nrc,
                        autofocus: true,              
                        decoration: InputDecoration(      
                          icon: Icon(Icons.credit_card),          
                          labelText: 'NRC', hintText: '12345'
                        )                                                                                       
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'Nombre de Materia es Requerida';
                          }else{        
                            if(isValidName(value)){
                              if(value.length<100){
                                return null;
                              }else{
                                return 'Longitud de Nombre MAX(100)';
                              }
                            }else{
                              return 'No se permiten caracteres especiales';
                            }
                          }                                               
                        },
                        onSaved: (String val) {
                          Nombre_Materia = val;
                        },
                        controller: nombre_materia,
                        autofocus: true,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Nombre de la Materia', hintText: 'Cálculo Diferencial'
                        )                                                                                       
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'Nombre del Salon es Requerido';
                          }else{        
                            return null;
                          }                                               
                        },
                        onSaved: (String val) {
                          Salon = val;
                        },
                        controller: salon,
                        autofocus: true,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Salon', hintText: 'CC04 - 101'
                        )                                                                                       
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'Dias es Requerido';
                          }else{        
                            return null;
                          }                                               
                        },
                        onSaved: (String val) {
                          Dias = val;
                        },
                        controller: dias,
                        autofocus: true,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Dias', hintText: 'LMV'
                        )                                                                                       
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'Hora es Requerido';
                          }else{        
                            return null;
                          }                                               
                        },
                        onSaved: (String val) {
                          Hora = val;
                        },
                        controller: hora,
                        autofocus: true,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.account_circle),                       
                          labelText: 'Hora', hintText: '9:00 - 11:00'
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
                print(NRC);
                print(Nombre_Materia);
                print(Salon); 
                print(Dias);
                print(Hora); 
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                //Si la informacion ha sido validada entonces Procedemos a insertar
                addCourse(NRC, Nombre_Materia, Salon, Dias, Hora);                
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


//--------------------------Validadores--------------------------------------------------
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

    void addCourse(String NRC,String Nombre_Materia,String Salon, String Dias, String Hora){
      Firestore.instance.runTransaction((transaction) async {
          await transaction.set(Firestore.instance.collection('cursos').document(), {
            'dias':Dias,            
            'hora': Hora,
            'nombre_materia': Nombre_Materia,
            'nrc': NRC,  
            'salon': Salon, 
          });
        });
    }          

//--------------------Obtener Lista de Cursos-------------------------------

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {  
  @override

  Widget build(BuildContext context) {

  return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cursos').snapshots(),
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
        return new ListView(children: getCourses(snapshot));        
      }
    );
  }
//---------------------Obtener Datos de Firebase-------------------------------------------------------------------
  getCourses(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => GestureDetector(
          onHorizontalDragUpdate:(a){deleteUserDialog(doc.documentID,doc["nombre_materia"].toString(),doc["nrc"].toString());
                  },
          child:
          new Card( child : 
          new ListTile(
            leading: FlutterLogo(),            
            title: new Text( doc["nombre_materia"].toString() ),
            subtitle: new Text( 
            doc["nrc"].toString() + '\n' + 
            doc["salon"].toString() + '\n' + 
            doc["hora"].toString() + '\n' + 
            doc["dias"].toString()
            ),                        
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed:(){
                    deleteUserDialog(doc.documentID,doc["nombre_materia"].toString(),doc["nrc"].toString());
                  }, 
                ) 
              ]
            ),
            onTap: () {
                    print("tapped");
                    Navigator.push(context,MaterialPageRoute(builder: (context) => lista_cursos2(doc["nrc"].toString(),doc["nombre_materia"].toString(),doc.documentID.toString())),);
                  },
          ),
        ))
      ).toList();
  }

  Future<void> deleteUserDialog(String id,String nombre_materia,String nrc) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.blue),
            child: AlertDialog(
            title: Text(
              'Eliminar Curso',
              style: TextStyle(
                color: Colors.white,                                   
              ),              
              textAlign: TextAlign.center,
            ),                        
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical, 
              child: Column(                
                children: <Widget>[
                  Text("¿Esta seguro que desea eliminar este curso ?",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),
                  Text('\n' + "Nombre: "+ nombre_materia , style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),                  
                  Text("NRC: "+ nrc, style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white))                               
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
                  deleteUser(id);
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              )
            ],      
         )
      );
    },
  );}

  //Función que elimina a un usuario de la BD
 void deleteUser(String id){   
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance.collection('cursos').document(id));
    });
  }

}