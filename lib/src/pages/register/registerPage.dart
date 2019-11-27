import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:control_classroom/src/services/AuthService.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  final matricula = TextEditingController();         
  final usuario = TextEditingController();         
  final correo = TextEditingController();   
  final codigo = TextEditingController();
  final clave = TextEditingController();   
  final rclave = TextEditingController();  
  final area = TextEditingController();    
  final _formKey = GlobalKey<FormState>(); 

  String Matricula='',Usuario='',Correo='',Codigo='',Clave='',RClave='',Area='';
  String matriculaValidator=null,correoValidator = null,usuarioValidator = null,claveValitador=null,rclaveValidator=null,codigoValidator=null,areaValidator=null;

  @override
  Widget build(BuildContext context) {

    //***
    //*   Contenedor Imagen
    //**/

    Widget contenedorImagen = Stack(
      alignment: const Alignment(0, 0.7),         
      children: [     
        Container(
          padding: const EdgeInsets.only(top: 10,bottom: 0),
          child: CircleAvatar(                    
            backgroundImage: AssetImage('assets/images/user.png'),
            radius: 65,
            backgroundColor: Colors.white70, 
          )
        )
      ],
    );

  //***
  //* Form Login
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
                                return matriculaValidator;
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
                        controller: matricula,
                        autofocus: false,              
                        decoration: InputDecoration(                             
                          icon: Icon(Icons.credit_card),                       
                          labelText: 'Matricula', hintText: 'eg. 201411393'
                        ),
                        keyboardType: TextInputType.number                                                                                       
                      ),                                                    
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'El Nombre es Requerido';
                          }else{   
                            if(isValidName(value)){
                              if(value.length<100){                                                                  
                                return usuarioValidator;                                
                              }else{                                
                                return 'Nombre muy largo MAX(100)';
                              }
                            }else{                              
                              return 'No se permiten caracteres especiales';
                            }                           
                          }                                               
                        },
                        onSaved: (String val) {
                          Usuario = val;
                        },
                        controller: usuario,
                        autofocus: false,              
                        decoration: InputDecoration(                             
                          icon: Icon(Icons.people),                       
                          labelText: 'Nombre', hintText: 'eg. Rafael'
                        )                                                                                       
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'El Correo es Requerido';
                          }else{                                                        
                            if(isValidEmail(value)){
                              if(value.length<100){                                                                  
                                return correoValidator;                                
                              }else{                                
                                return 'Correo muy largo MAX(100)';
                              }
                            }else{                              
                              return 'Correo no valido';
                            }                      
                          }                                               
                        },
                        onSaved: (String val) {
                          Correo = val;
                        },
                        controller: correo,
                        autofocus: false,              
                        decoration: InputDecoration(                             
                          icon: Icon(Icons.email),                       
                          labelText: 'Correo', hintText: 'eg. jose@gmail.com'
                        )                                                                                       
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'La Contraseña es Requerida';
                          }else{    
                            return codigoValidator;                  
                          }                                               
                        },
                        onSaved: (String val) {
                          Codigo = val;
                        },
                        controller: codigo,
                        autofocus: false,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.lock),                       
                          labelText: 'Contraseña', hintText: 'eg. M&PassWORD19'
                        )                                                                                       
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'La Nueva Contraseña es Requerida';
                          }else{   
                            if(value.length>=6){                              
                              return claveValitador;
                            }else{
                              return 'La contraseña debe tener MIN 6 caracteres';
                            }                            
                          }                                               
                        },
                        onSaved: (String val) {
                          Clave = val;
                        },
                        controller: clave,
                        autofocus: false,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.vpn_key),                       
                          labelText: 'Contraseña', hintText: 'eg. M&PassWORD19'
                        )                                                                                       
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'Confirmacion de Contraseña Requerida';
                          }else{    
                            if(value.length>=6){                              
                              return rclaveValidator;
                            }else{
                              return 'La contraseña debe tener MIN 6 caracteres';
                            }                           
                          }                                               
                        },
                        onSaved: (String val) {
                          RClave = val;
                        },
                        controller: rclave,
                        autofocus: false,              
                        decoration: InputDecoration(   
                          icon: Icon(Icons.vpn_key),                       
                          labelText: 'Confirmar Contraseña', hintText: 'eg. M&PassWORD19'
                        )
                      ),
                      TextFormField(
                        validator: (value){
                          if (value.isEmpty) {                            
                            return 'El Area es Requerida';
                          }else{   
                            return areaValidator;                           
                          }                                               
                        },
                        onSaved: (String val) {
                          Area = val;
                        },
                        controller: area,
                        autofocus: false,              
                        decoration: InputDecoration(                             
                          icon: Icon(Icons.style),                       
                          labelText: 'Area', hintText: 'eg. Tecnologias'
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
                                                                                                        
                          final form = _formKey.currentState;
                          form.save();
                          
                          if(Clave==RClave){
                            setState(() {
                              this.rclaveValidator = null;
                              this.claveValitador = null;                              
                            });
                          }else{
                            setState(() {
                              this.matriculaValidator = matriculaValidator;
                              this.usuarioValidator = usuarioValidator;  
                              this.correoValidator = correoValidator;
                              this.usuarioValidator = usuarioValidator;
                              this.rclaveValidator = 'Las Contraseñas NO coinciden';
                              this.claveValitador = 'Las Contraseñas NO coinciden';
                              this.areaValidator = areaValidator;
                              this.codigoValidator = codigoValidator;
                            });
                          }

                          //Validacion email
                          String responseEmail = await Provider.of<AuthService>(context).emailExist(Correo); 
                                                                           
                          if(responseEmail==null){                                                       
                            setState(() {
                              this.correoValidator = null;
                            });                               
                          }else{
                            print('esta ocupado');
                              setState(() {
                                this.matriculaValidator = matriculaValidator;
                                this.usuarioValidator = usuarioValidator;
                                this.correoValidator = responseEmail;
                                this.usuarioValidator = usuarioValidator;
                                this.codigoValidator = codigoValidator;
                                this.rclaveValidator = rclaveValidator;
                                this.claveValitador = claveValitador;
                                this.areaValidator = areaValidator;
                              });
                          }
                          
                          //Validacion USER
                          String response = await Provider.of<AuthService>(context).userExist(Matricula,Codigo);
                                                                     
                          if(response==null){                                                       
                            setState(() {
                              print('* existe usuario');
                              this.matriculaValidator = null;
                              this.codigoValidator = null;
                            });                               
                          }else{                            
                              setState(() {
                                this.matriculaValidator = response;
                                this.usuarioValidator = usuarioValidator;
                                this.correoValidator = correoValidator;
                                this.usuarioValidator = usuarioValidator;
                                this.codigoValidator = response;
                                this.rclaveValidator = rclaveValidator;
                                this.claveValitador = claveValitador;
                                this.areaValidator = areaValidator;
                              });
                          }
                          
                          if (form.validate()) {                          
                            print('LISTO PARA ENVIAR');
                            FirebaseUser user = await Provider.of<AuthService>(context).register(Matricula,Correo,Clave,Usuario,Codigo,Area);
                            if(user==null){
                              String mensaje='Este usuario ya ha sido activado';
                              String titulo='Registrar Usuario';
                              return Mensaje(context,mensaje,titulo);
                            }else{
                              Navigator.pop(context);
                            }                            
                          }

                        },              
                        child: Text('Registrar',style: TextStyle(  fontWeight: FontWeight.bold),),
                        )
                        )
                      ) 
                    ] 
                  ),
              ),
        )
      ],
    );



    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesión"),
        centerTitle: true
      ),        
      body: 
          ListView(
            children:[   
              contenedorImagen,
              formLogin              
            ]                          
          )
        
    );
  }  

  bool isValidName(String str){
    Pattern pattern = r'^[a-zA-Z0-9 ]*$';
    RegExp regex = new RegExp(pattern);      
      if(regex.hasMatch(str)){          
        return true;
      }else{          
        return false;
      }      
  }

  bool isValidEmail(String str){
      Pattern pattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
      RegExp regex = new RegExp(pattern);      
        if(regex.hasMatch(str)){          
          return true;
        }else{          
          return false;
        }      
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
