import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class PantallaActAlumnos extends StatelessWidget {
  String idmat, nombmat,docid;
  PantallaActAlumnos(this.idmat,this.nombmat,this.docid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nombmat),
        backgroundColor: Colors.blue, 
      ),
      body: ListPage4(this.idmat,this.docid,this.nombmat),
    );
  }


}

class ListPage4 extends StatefulWidget {
  String idmat;
  String docid;
  String nombrema;
  ListPage4(this.idmat,this.docid,this.nombrema);
  @override
  _ListPageState4 createState() => _ListPageState4(this.idmat,this.docid,this.nombrema);
}

class _ListPageState4 extends State<ListPage4> {  
  String idmat;
  String docid;
  String nombrema;
  _ListPageState4(this.idmat,this.docid,this.nombrema);
  
  @override

  Widget build(BuildContext context) {
  print(idmat);
  return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cursos').document(docid).collection("actividades").where("alumno", isEqualTo: nombrema).snapshots() ,
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
          onTap:(){updateActAlumnoDialog(docid.toString(),doc["nombre"].toString(),doc.documentID);
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
                    updateActAlumnoDialog(docid.toString(),doc["nombre"].toString(),doc.documentID);
                  }, 
                ) 
              ]
            ),
          ),
        )
      )
      ).toList();
  }

  Future<ConfirmAction> updateActAlumnoDialog(String id,String nombre,String id2) async {
  String docidd=docid;
  String Calificacion=''; 
  const Locale('es');
  final calificacion = TextEditingController();   
  final _formKey = GlobalKey<FormState>();  
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
      child: AlertDialog(
        title: Text('Colocar Calificacion'),         
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
                            if(isUnsignedIntegers(value)){
                              return null;
                              }else{                              
                              return 'La Calificacion debe de ser numerico';
                            }                                             
                          }                                               
                        },
                        onSaved: (String val) {
                          Calificacion = val;
                        },
                        controller: calificacion,
                        autofocus: true,              
                        decoration: InputDecoration(      
                          icon: Icon(Icons.credit_card),          
                          labelText: 'Calificacion', hintText: 'Numero'
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
                print(Calificacion);
                print('◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤');
                //Si la informacion ha sido validada entonces Procedemos a insertar
                addCalificacion(id,Calificacion,id2);                
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
 void addCalificacion(String id, String matricula,String id2){   
    Firestore.instance.runTransaction((transaction) async {
      await Firestore.instance..collection('cursos').document(id).collection("actividades").document(id2).updateData({'calificacion': matricula});
    });
  }
}
