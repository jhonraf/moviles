import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService with ChangeNotifier{
    
  final FirebaseAuth _auth = FirebaseAuth.instance;  
  final Firestore _db = Firestore.instance;

  AuthService() {
    print("🔒 AuthService Loaded ...");    
  }

  Future<void> salir() async {    
    await _auth.signOut();
  }

  Future<DocumentSnapshot> getUser() async {    
    print('📌 Obteniendo Usuario Actual ...');    
    FirebaseUser user = await _auth.currentUser();
    if(user!=null){  
      var emailExistQuery = Firestore.instance.collection('usuarios')
        .where('correo', isEqualTo: user.email);
      var querySnapshots = await emailExistQuery.getDocuments();
      DocumentSnapshot userFromFirestore = await Firestore.instance.collection('usuarios').document(querySnapshots.documents[0].documentID).get();                                                
      return userFromFirestore;
    }else{
      return null;
    }
  }

  Future<String> userExist(String matricula,String codigo) async {  
    print('📌 Metodo Verificar si Usuario existeS');
    var emailExistQuery = Firestore.instance.collection('usuarios')
      .where('matricula', isEqualTo: matricula).where('codigo',isEqualTo:codigo);
    var querySnapshots = await emailExistQuery.getDocuments();
    var totalEquals = querySnapshots.documents.length;   
    if(totalEquals>=1){        
      return null;
    }else{
      return 'Nombre y/o Contraseña incorrectos';
    }    
  }

  Future<String> emailExist(String email) async {  
    print('📌 Metodo Verificar Email');
    var emailExistQuery = Firestore.instance.collection('usuarios')
      .where('correo', isEqualTo: email);
    var querySnapshots = await emailExistQuery.getDocuments();    
    var totalEquals = querySnapshots.documents.length;   
    if(totalEquals>=1){
      return 'El email ya ha sido tomado';
    }else{
      return null;
    }    
  }

  Future<DocumentSnapshot> signInWithEmailAndPassword(String matricula, String password ) async {    
    print('📌 Inicio de Sesion Manual');

    var userExistQuery = _db.collection('usuarios')
    .where('matricula', isEqualTo: matricula);
    var querySnapshots = await userExistQuery.getDocuments();
    var totalEquals = querySnapshots.documents.length;  
    if(totalEquals>=1){   
      if(querySnapshots.documents[0].data['estado']==false){
        final Map<String, dynamic> doc ={
          'estado':false,
          'mensaje':'La Cuenta esta Desactivada'
        };

        return querySnapshots.documents[0];
      }else{
        String email = querySnapshots.documents[0].data['correo'];      
        final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
        assert(user != null);
        assert(await user.getIdToken() != null);    
        DocumentSnapshot userFromFirestore = await Firestore.instance.collection('usuarios').document(querySnapshots.documents[0].documentID).get();                       
        return userFromFirestore;
      }
    }else{
      return null;
    }    
          
  }

  Future<FirebaseUser> register(matricula,email, password,usuario,codigo,area) async {    
    print('📌 Metodo Registrar Usuario');                 
    
    var userExistQuery = _db.collection('usuarios')
      .where('matricula', isEqualTo: matricula).where('codigo',isEqualTo:codigo);
    var querySnapshots = await userExistQuery.getDocuments();
    var totalEquals = querySnapshots.documents.length;  

    print(querySnapshots.documents[0].data['codigo']);

    
    if(querySnapshots.documents[0].data['estado']==false){

    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,          
    );    
    assert(user != null);
    assert(await user.getIdToken() != null);                        
         
      if(totalEquals>=1){        
        print(querySnapshots.documents[0].documentID);
        updateUserData(querySnapshots.documents[0].documentID,email,area,usuario);
      }else{
        print('Error');
      }

        var result = await FirebaseAuth.instance.signOut();
        return user;  
    
    }else{
      return null;
    }
    
      
                
  }

   void updateUserData(String uid,String correo,String area,String usuario) async {
    print('Entra al metodo actualizar');
    print(uid);
    print(area);

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(Firestore.instance.collection('usuarios').document(uid),{
        'uid': uid,        
        'usuario': usuario,                                    
        'correo': correo,                                    
        'area':area,
        //'codigo':null,
        'estado':true
      });           
    });

    }
     void addUser(String Matricula,String Codigo){   
      Firestore.instance.runTransaction((transaction) async {
          await transaction.set(Firestore.instance.collection('usuarios').document(), {
            'matricula':Matricula,            
            'estado': false,
            'codigo': Codigo,          
          });
        });
    }
}
