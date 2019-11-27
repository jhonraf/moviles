import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

enum ConfirmAction { CANCEL, ACCEPT }


//elementos globales
List<String> ids = new List<String>();
List<String> nomb = new List<String>();
List<String> clav = new List<String>();
List<bool> idb = new List<bool>();
String idd;
int counter = 0;

  void incrementCounter() {
      counter++;
  }

   void decrementCounter() {
      counter--;    
  }


//clase principal de alertas
class NotificacionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),

      ),
      body: ListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FutureBuilder<ConfirmAction>(
              future: addAlertDialog(context),
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


//pantalla para elegir los destinatarios
class Destino extends StatelessWidget {
  String id;
  Destino(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Selcciona el destino"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Grupos'),
              onTap: () {
                print("tapped");
                idb.clear();
                nomb.clear();
                clav.clear();
                ids.clear();
                idd=id;
                Navigator.push(context,MaterialPageRoute(builder: (context) => SelGrupos(id)),);
                
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Alumnos'),
              onTap: () {
                print("tapped");
                idb.clear();
                nomb.clear();
                clav.clear();
                ids.clear();
                idd=id;
                Navigator.push(context,MaterialPageRoute(builder: (context) => SelAlumnos(id)),);
              },
            ),
          ],
        ),
    );
  }
}


//pantalla para los grupos
class SelGrupos extends StatelessWidget {
  String id;
  SelGrupos(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agrega Grupos"),
      ),
      body: ListPageGroups(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(guarda()==true){
            FutureBuilder<ConfirmAction>(
                future: saveAlertsDialog(context,0),
                builder: (context, snapshot){
                  print('Se guardo la alerta');
                }
            );
          }else {
            _showDialog(context);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  bool guarda(){
    for(int i=0;i<idb.length;i++){
      if(idb[i]==true)
        return true;
    }
    return false;
  }
}

//pantalla para los alumnos
class SelAlumnos extends StatelessWidget {
  String id;
  SelAlumnos(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agrega Alumnos"),
      ),
      body: ListPageUsers(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(guarda()==true){
            FutureBuilder<ConfirmAction>(
                future: saveAlertsDialog(context,1),
                builder: (context, snapshot){
                  print('Se guardo la alerta');
                }
            );
          }else {
            _showDialog(context);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
  bool guarda(){
    for(int i=0;i<idb.length;i++){
      if(idb[i]==true)
        return true;
    }
    return false;
  }
}
//-------------------------------------------------------------------



//-------------------------------------------------------------------
//gestiona la lista de alertas
Future<ConfirmAction> addAlertDialog(BuildContext context) async {
  String Titulo='', Mensaje='';
  final titulo = TextEditingController();
  final mensaje = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            title: Text('Crear Alerta'),
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
                                return 'El titulo es requerido';
                              }else{
                                return null;
                              }
                            },
                            onSaved: (String val) {
                              Titulo= val;
                            },
                            controller: titulo,
                            autofocus: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.title),
                                labelText: 'titulo', hintText: ' Sigueinte clase'
                            )
                        ),
                        TextFormField(
                            validator: (value){
                              if (value.isEmpty) {
                                return 'El mensaje es requerido';
                              }else{
                                return null;
                              }
                            },
                            onSaved: (String val) {
                              Mensaje = val;
                            },
                            controller: mensaje,
                            autofocus: true,
                            decoration: InputDecoration(
                                icon: Icon(Icons.message),
                                labelText: 'mensaje', hintText: ' haz reprobado'
                            )
                        )
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
                    print(Titulo);
                    addAlert(Titulo, Mensaje);
                    Navigator.of(context).pop(ConfirmAction.ACCEPT);
                  }else{
                    print('Datos en el Form NO validos');
                  }
                },
              )
            ],
          )
      );
    },
  );
}

void addAlert(String Titulo,String Mensaje){
  Firestore.instance.runTransaction((transaction) async {
    await transaction.set(Firestore.instance.collection('alertas').document(), {
      'mensaje':Mensaje,
      'titulo': Titulo,
    });
  });
}


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
 
  Widget build(BuildContext context) {

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('alertas').snapshots(),
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
          return new ListView(children: getAlerts(snapshot));
        }
    );
  }
//---------------------Obtener Datos de Firebase-------------------------------------------------------------------
  getAlerts(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => GestureDetector(
        onHorizontalDragUpdate:(a){deleteAlertDialog(doc.documentID,doc["titulo"].toString(),doc["mensaje"].toString());},
        child: new Card( child :
        new ListTile(
          leading: FlutterLogo(),
          title: new Text(doc['titulo'].toString()),
          subtitle: new Text(
              doc["mensaje"].toString()
          ),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed:(){
                    deleteAlertDialog(doc.documentID,doc["titulo"].toString(),doc["mensaje"].toString());
                  },
                )
              ]
          ),
          onTap: () {
            print("tapped");
            //Navigator.pushNamed(context, '/destino');
            //Navigator.push(context,MaterialPageRoute(builder: (context) => lista_cursos2(doc["nrc"].toString(),doc["nombre_materia"].toString(),doc.documentID.toString())),);
            Navigator.push(context,MaterialPageRoute(builder: (context) => Destino(doc.documentID.toString())),);
          },
        ),
        ))
    ).toList();
  }

  Future<void> deleteAlertDialog(String id,String titulo,String mensaje ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.blue),
            child: AlertDialog(
              title: Text(
                'Eliminar Alerta',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Text("¿Esta seguro que desea eliminar esta alerta ?",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),
                    Text('\n' + "Alerta: "+ titulo, style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),
                    Text("mensaje: "+ mensaje, style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white))
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.white,
                  child: const Text('CANCELAR'),
                  onPressed: () {
                    Navigator.of(context).pop(ConfirmAction.CANCEL);
                    print('Cancelar Eliminacion');
                  },
                ),
                FlatButton(
                  color: Colors.white,
                  child: const Text('ACEPTAR'),
                  onPressed: () {
                    print(id);
                    deleteAlert(id);
                    Navigator.of(context).pop(ConfirmAction.ACCEPT);
                    decrementCounter();
                  },
                )
              ],
            )
        );
      },
    );
  }

  //Función que elimina a un usuario de la BD
  void deleteAlert(String id){
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(Firestore.instance.collection('alertas').document(id));
    });
  }
}





//para gestionar lista de grupos
class ListPageGroups extends StatefulWidget {
  @override
  _ListPageStateGroups createState() => _ListPageStateGroups();
}

class _ListPageStateGroups extends State<ListPageGroups> {
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
        },
    );
  }
  createIds(String _id){
    idb.add(false);
    ids.add(_id);
    clav.add('');
    nomb.add('');
    return ' - ';
  }
  getCourses(AsyncSnapshot<QuerySnapshot> snapshot) {
    //a++;
    return snapshot.data.documents.map((doc) => GestureDetector(
      onHorizontalDragUpdate:(a){},
      child: new Card(
        child : new ListTile(
          leading: FlutterLogo(),
          title: new Text(doc['nombre_materia'].toString()),
          subtitle: new Text(createIds(doc.documentID)+doc['nrc'].toString()),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Checkbox(
                  value:idb[ids.indexOf(doc.documentID)],
                  onChanged: (bool value) {
                    setState(() {
                      int _id=ids.indexOf(doc.documentID);
                      idb[_id] = value;
                      if(value==true) {
                        ids[_id] = doc.documentID.toString();
                        nomb[_id] = doc['nombre_materia'];
                        clav[_id] = doc['nrc'].toString();
                      }
                    });
                  },
                ),
              ]
          ),
        ),
      )
    )).toList();
  }
}

//para gestionar lista de usuarios
class ListPageUsers extends StatefulWidget {
  @override
  _ListPageStateUsers createState() => _ListPageStateUsers();
}

class _ListPageStateUsers extends State<ListPageUsers> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('usuarios').snapshots(),
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
      },
    );
  }
  createIds(String _id){
    idb.add(false);
    ids.add(_id);
    clav.add('');
    nomb.add('');
    return ' - ';
  }
  getCourses(AsyncSnapshot<QuerySnapshot> snapshot) {
    //a++;
    return snapshot.data.documents.map((doc) => GestureDetector(
        onHorizontalDragUpdate:(a){},
        child: new Card(
          child : new ListTile(
            leading: FlutterLogo(),
            title: new Text(doc['usuario'].toString()),
            subtitle: new Text(createIds(doc.documentID)+doc['matricula'].toString()),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Checkbox(
                    value:idb[ids.indexOf(doc.documentID)],
                    onChanged: (bool value) {
                      setState(() {
                        int _id=ids.indexOf(doc.documentID);
                        idb[_id] = value;
                        if(value==true) {
                          ids[_id] = doc.documentID.toString();
                          nomb[_id] = doc['usuario'];
                          clav[_id] = doc['matricula'].toString();
                        }
                      });
                    },
                  ),
                ]
            ),
          ),
        )
    )).toList();
  }
}

//guarda las alertas dependiendo de grupos o de ususarios (op)
Future<void>  saveAlertsDialog(BuildContext context, int op) async {
  String id,materia,nrc;
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Theme(
          data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.blue),
          child: AlertDialog(
            title: Text(
              'Enviar Alerta',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Text("¿Desea agregar la alerta para los elementos seleccionados ?",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white)),
                  Text('\n' + "Todos los estudiantes con esa información serán notificaos", style: TextStyle(fontWeight: FontWeight.normal, color:Colors.white)),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.white,
                child: const Text('CANCELAR'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              ),
              FlatButton(
                color: Colors.white,
                child: const Text('ACEPTAR'),
                onPressed: () {
                    for (int i = 0; i < idb.length; i++) {
                      if (idb[i]) {
                        addAlerts(ids[i], nomb[i], clav[i],op);
                      }
                    }
                    Navigator.of(context).pop(ConfirmAction.ACCEPT);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Destino(idd)),);
                    incrementCounter();
                  },
              )
            ],
          )
      );
    },
  );
}

void addAlerts(String id,String _nomb,String _clav,int op) {
    if(op==0) {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(Firestore.instance.collection('alertas').document(idd).collection('grupos').document(), {
            'materia': _nomb,
            'nrc': _clav,
        });
      });
    }else{
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(Firestore.instance.collection('alertas').document(idd).collection('alumnos').document(), {
          'usuario': _nomb,
          'matricula': _clav,
        });
      });
    }
}


void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("¡Nada seleccionado!"),
        content: new Text('Selecciona primero los elementos '),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

