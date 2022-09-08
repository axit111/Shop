

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'common.dart';

enum ApplicatinLoginState {loggetOut,looggedIn}

class ApplicationState extends ChangeNotifier{
  User? user;
  ApplicatinLoginState loginState = ApplicatinLoginState.loggetOut;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  ApplicationState(){
    init();
  }

  Future<void> init() async{
    FirebaseAuth.instance.userChanges().listen((userFir) {
      if(userFir != null){
        loginState = ApplicatinLoginState.looggedIn;
        user = userFir;
      }else{
        loginState =ApplicatinLoginState.loggetOut;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email,String password,void Function(FirebaseAuthException e)errorCallBack)async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      errorCallBack(e);
    }
  }

  Future<void> signUp(String email,String password,void Function(FirebaseAuthException e)errorCallBack)async{
    try{
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //Stripe user create
      await CommonUtil.backendCall(userCredential.user!,CommonUtil.stripeUserCreate);
    }on FirebaseAuthException catch(e){
      errorCallBack(e);
    }
  }

  void signOut() async{
    await _auth.signOut();
  }
}