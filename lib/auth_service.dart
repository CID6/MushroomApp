

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'private_messaging.dart';

String getUid(String snapshot){
  const start = "{";
  const end = ":";
  final startIndex = snapshot.indexOf(start);
  final endIndex = snapshot.indexOf(end,startIndex+start.length);
  return snapshot.substring(startIndex + start.length,endIndex);
}

Future<void> getKey() async{
    String user = FirebaseAuth.instance.currentUser!.uid;
    DataSnapshot snapshot = (await FirebaseDatabase.instance.ref().child('users').orderByChild('uid').equalTo(user).once() as DatabaseEvent).snapshot;
    userKey = getUid(snapshot.value.toString());
    loggedUser = (await  FirebaseDatabase.instance.ref().child('users').child(userKey).get()).value as Map;
    DB = FirebaseDatabase.instance.ref().child('users').child(userKey).child('posts');
    posts = FirebaseDatabase.instance.ref().child('users').child(userKey).child('posts');
    follows = FirebaseDatabase.instance.ref().child('users').child(userKey).child('follows');
}



class AuthService{

  bool userExists = false;
  

  Future<void> checkifExists(String id) async{
    DataSnapshot snapshot = (await FirebaseDatabase.instance.ref().child('users').orderByChild('uid').equalTo(id).once() as DatabaseEvent).snapshot;
    userExists = snapshot.value!=null;
  }

  

  handleAuthState(BuildContext context){
    // return StreamBuilder(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (BuildContext context, snapshot){
      signOut();
        if(FirebaseAuth.instance.currentUser!=null){
          
          return ProfilePage();
        }
        else{
          return LoginPage();
        }
      //},
    //);
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>["email"]
    ).signIn();
    
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var loggedIn = await FirebaseAuth.instance.signInWithCredential(credential);
    if(userExists==false){
      await checkifExists(FirebaseAuth.instance.currentUser!.uid);
    }
    if(userExists || ModalRoute.of(context)?.settings.name == "RegisterPage"){
      await getKey();
      return ProfilePage();
    }
    else{
      signOut();
      return LoginPage(true);
    }
    //return loggedIn;
  }

  signOut() async{
    pm.value.tryb.value = FirebaseDatabase.instance.ref().child("emptyQuery");
    recipient.value.tryb.value = "";
    userExists = false;
    initConv = true;
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }
}