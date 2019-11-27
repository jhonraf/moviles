import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_classroom/src/pages/register/registerPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:control_classroom/src/services/AuthService.dart';
import 'package:flutter/services.dart';
import 'package:control_classroom/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final clavelogin = TextEditingController();   
  final matriculalogin = TextEditingController();   
  final _formKey = GlobalKey<FormState>();  
  

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String Clave='',Matricula='',titulo='',mensaje='';
    

    //***
    //*   Contenedor Imagen
    //**/

    Widget contenedorImagen = Stack(
      alignment: const Alignment(0, 0.7),         
      children: [     
        Container(
          padding: const EdgeInsets.only(top: 10,bottom: 0),
          child: CircleAvatar(                    
            backgroundImage: AssetImage('assets/images/security.png'),
            radius: 65,
            backgroundColor: Colors.white70, 
          )
        )
      ],
    );

    //***
    //*   Form Login
    //**/

    Widget formLogin = Stack(
      alignment: const Alignment(0, 0.7),         
      children: [     
        Container(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: new Form(
                key: _formKey,           
                  child: Column(     
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,         
                    children: <Widget>[                                                      
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'La Matricula es Requerida';
                          }else{  
                            if(isUnsignedIntegers(value)){
                              if(value.length==9){
                                return null;
                              }else{
                                return 'Longitud de Matricula debe ser (9)';
                              }                    
                            }else{                              
                              return 'La matricula debe ser un numero';
                            }  
                          }                                               
                        },
                        onSaved: (String val) {
                          Matricula = val;
                        },
                        controller: matriculalogin,
                        autofocus: false,              
                        decoration: InputDecoration(                             
                          icon: Icon(Icons.credit_card),                       
                          labelText: 'Matricula', hintText: 'eg. 201434945'
                        ),
                        keyboardType: TextInputType.number
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'La Contraseña es Requerida';
                          }else{                              
                          }                                               
                        },
                        onSaved: (String val) {
                          Clave = val;
                        },
                        controller: clavelogin,
                        autofocus: false,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.vpn_key),                       
                          labelText: 'Contraseña', hintText: 'eg. M&PassWORD19'
                        )                                                                                       
                      ),
                      SizedBox(                        
                        width: double.infinity,  
                        child: Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () async {       
                          
                          //Oculta el teclado
                          FocusScope.of(context).requestFocus(FocusNode());

                          /*
                          final snackBar = SnackBar(
                            content: Text('Cargando ...'),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {                            
                                },
                              ),
                              duration: const Duration(minutes: 5),
                          );

                          final snackBarConnection = SnackBar(
                            content: Text(
                              'No hay Conexion a Internet ...',
                            style: TextStyle(color: Colors.white),),
                              action: SnackBarAction(
                                label: '',
                                onPressed: () {                            
                                },
                              ),
                            backgroundColor: Colors.red
                          );
                          */                                                                           
                          final form = _formKey.currentState;
                          form.save();
                          
                          if (form.validate()) {   
                            
                            try{

                              DocumentSnapshot user = await Provider.of<AuthService>(context).signInWithEmailAndPassword(Matricula, Clave);
                              
                              if(user==null){
                                String mensaje='Correo y/o Contraseña Incorrectos';
                                String titulo='Iniciar Sesion';
                                return Mensaje(context,mensaje,titulo);
                              }else{
                                if(user.data['estado']==false){
                                  String mensaje='Esta cuenta no esta activa';
                                  String titulo='Iniciar Sesion';
                                  return Mensaje(context,mensaje,titulo);
                                }else{
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => MyApp()));
                                }                                
                              }        

                            } on PlatformException catch (error){
                              switch (error.code) {                                
                                case 'ERROR_USER_NOT_FOUND':
                                    mensaje='Correo y/o Contraseña Incorrectos';
                                    titulo='Inicio de Sesion';
                                   // _scaffoldKey.currentState.removeCurrentSnackBar();                                    
                                  break;
                                case 'ERROR_WRONG_PASSWORD':
                                    //En teoria este error no deberia suceder si se hace correcta la valicacion MIN(5)
                                    mensaje='Correo y/o Contraseña Incorrectos';
                                    titulo='Inicio de Sesion';
                                  //  _scaffoldKey.currentState.removeCurrentSnackBar();                                    
                                  break;
                                case 'FirebaseException':
                                  mensaje='No hay Conexion a Internet';
                                  titulo='Conexion a Internet';
                                  //_scaffoldKey.currentState.removeCurrentSnackBar();                                    
                                  //_scaffoldKey.currentState.showSnackBar(snackBarConnection);
                                break;
                                default:
                                  mensaje=error.message;
                                  titulo='E R R O R';
                              }                              
                              return Mensaje(context,mensaje,titulo);
                            } catch(e){
                              print('Error Desconocido');
                              print(e.toString());
                            }         
                                                    
                          }                                                                                                            
                        },              
                        child: Text('Iniciar Sesión',style: TextStyle(  fontWeight: FontWeight.bold),),
                        )
                        )
                      ) 
                    ] 
                  ),
              ),
        )
      ],
    );

     //***
    //*   Contenedor Imagen
    //**/

    Widget Links = Stack(
      alignment: const Alignment(0, 0.7),         
      children: [     
        Container(
          padding: const EdgeInsets.only(top: 10,bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Text("Registrar", style: TextStyle(
                  decoration: TextDecoration.underline, 
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,                  
                  )
                ),
                onTap: () {
                  print('registrar');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );

                }                
              ),
              Text('/'),
              GestureDetector(
                child: Text("Olvidar", style: TextStyle(
                  decoration: TextDecoration.underline, 
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,                  
                  )
                ),
                onTap: () {
                  print('Olvidar');
                }                
              ),
            ],
          ),
        )
      ],
    );

     return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesión"),
        centerTitle: true
      ),        
      key:_scaffoldKey,
        body: Builder(
          builder: (context) => 
          ListView(
            children:[   
              contenedorImagen,
              formLogin,
              Links
            ]                          
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Agregando usuario');
            Provider.of<AuthService>(context).addUser('201012345','ABCD'); 
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
    );

  } 

  bool isUnsignedIntegers(String str) {
      Pattern pattern = r'^[0-9]*$';
      RegExp regex = new RegExp(pattern);      
        if(regex.hasMatch(str)){        
          return true;
        }else{          
          return false;
        }                  
    }

  

    Future Mensaje(BuildContext context,mensaje,titulo) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text(titulo,style: TextStyle(),textAlign: TextAlign.center,),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
                child: Text('Entendido'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

}