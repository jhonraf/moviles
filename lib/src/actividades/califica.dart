import 'package:control_classroom/src/actividades/calificaractividades.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class PantallaCalifica extends StatelessWidget {
  String idmat, nombmat,docid;
  PantallaCalifica(this.idmat,this.nombmat,this.docid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nombmat),
        backgroundColor: Colors.blue, 
      ),
      body: ListPage3(this.idmat,this.docid),
    );
  }

    //---------------Dialogo Insertar Alumnos-------------------------------
 
}
class ListPage3 extends StatefulWidget {
  String idmat;
  String docid;
  ListPage3(this.idmat,this.docid);
  @override
  _ListPageState3 createState() => _ListPageState3(this.idmat,this.docid);
}

class _ListPageState3 extends State<ListPage3> {  
  String idmat;
  String docid;
  _ListPageState3(this.idmat,this.docid);
  
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
          onTap:(){Navigator.push(context,MaterialPageRoute(builder: (context) => PantallaActAlumnos(this.idmat,doc["matricula"].toString(),this.docid)),);
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
                  icon: new Icon(Icons.arrow_forward),
                  onPressed:(){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => PantallaActAlumnos(this.idmat,doc["matricula"].toString(),this.docid)),);
                  }, 
                ) 
              ]
            ),
          ),
        )
      )
      ).toList();
  }

  
}
