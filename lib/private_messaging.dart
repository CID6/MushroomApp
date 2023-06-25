
import 'package:flutter/material.dart';
import 'main.dart';
import 'auth_service.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';


var initConv = true;

class PMuser{
  ValueNotifier<DatabaseReference> tryb = ValueNotifier(FirebaseDatabase.instance.ref().child("emptyQuery"));
  PMuser({required this.tryb});
}
class PMuserNotifier extends ValueNotifier<PMuser>{
  PMuserNotifier({required PMuser value}): super(value);

  void change(DatabaseReference tryb){
    if(value.tryb.value!=tryb){
      value.tryb.value = tryb;
      notifyListeners();
    }
  }
}

class Conv{
  ValueNotifier<bool> tryb = ValueNotifier(false);
  Conv({required this.tryb});
}
class ConvNotifier extends ValueNotifier<Conv>{
  ConvNotifier({required Conv value}): super(value);

  void change(bool tryb){
      value.tryb.value = tryb;
      notifyListeners();
  }
}


Key _klucz = Key(DateTime.now().millisecondsSinceEpoch.toString());
String recipient = "";


class PMPage extends StatefulWidget{
  @override
  State<PMPage> createState() => _PMPage();
}


class _PMPage extends State<PMPage>{
  var recipientController = TextEditingController();

  void checkIfNameExists() async{
    DatabaseEvent event = await FirebaseDatabase.instance.ref().child('users').orderByChild('name').equalTo(recipientController.text).once();
    if(event.snapshot.exists){
      final subString = getUid(event.snapshot.value.toString());
      DatabaseEvent secEvent = await FirebaseDatabase.instance.ref().child('users').child(userKey).child('conversations').orderByChild('name').equalTo(recipientController.text).once();
      if(secEvent.snapshot.exists == false){
        DatabaseReference ref = FirebaseDatabase.instance.ref().child('users')
        .child(userKey).child('conversations').child(subString);
        ref.set({"name":recipientController.text});
        ref = FirebaseDatabase.instance.ref().child('users').child(subString).child('conversations').child(userKey);
        ref.set({"name":loggedUser["name"]});
        //AddEmptyConvo
      }
      initConv = true;
      Navigator.of(context).pop();
    }
    else{
      initConv = false;
      cn.value.tryb.value = !cn.value.tryb.value;
    
    }
  }



  final nameController = TextEditingController();
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context){
    
    return Column(children: [ 
      Expanded(flex:6,child: Container(
        child: Row(children: [
          Expanded(flex:1,child: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
            border: Border(right: BorderSide(width: 2,color: Colors.black))),
                child: FirebaseAnimatedList(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                query: FirebaseDatabase.instance.ref().child('users').child(userKey).child('conversations'), 
                itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation animation,int index) {
                  Map post = snapshot.value as Map;
                  post['key'] = snapshot.key;
                  return  Padding(
                    padding:const EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child:Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    child:ListTile( 
                    leading: Text("@${post['name']}"),
                    onTap: (){
                      setState(() {
                        pm.value.tryb.value = FirebaseDatabase.instance.ref().child('users').child(userKey).child("conversations").child(post["key"]).child('messages');
                        _klucz = Key(DateTime.now().millisecondsSinceEpoch.toString());
                        recipient = post['name'];
                      });
                      
                    },
                  )));}))), 
          
          
          Expanded(flex:2,child: Container(decoration:const BoxDecoration(color: Colors.blue),
            child: Column(children: [
              Expanded(flex:1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                  color: Colors.teal
                  ),
                  child: Text(" Recipient: ${recipient}",
                  ),)),
              Expanded(flex: 10,child:Container(
                child:ValueListenableBuilder(
                  valueListenable: pm.value.tryb,
                  builder: (BuildContext context, Query value, Widget? child){
                    return FirebaseAnimatedList(
                      query: pm.value.tryb.value,
                      key: _klucz,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation animation, int index){
                        Map post = snapshot.value as Map;
                        post["key"] = snapshot.key;
                        return  Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: post["from"]==loggedUser["name"]? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left:post["from"]==loggedUser["name"]?0:5,right:post["from"]==loggedUser["name"]?5:0),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 42, 3, 150),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(
                                    post["text"],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                    )
                                  ),
                                ),
                              )
                            ],
                          )
                        );
                      }, 
                    
                    );}),)
          )]),
          ))
        ],)
      ,)),
    Expanded(
      flex: 1,
      child: Row(
        children: [
          Expanded(
                flex: 1,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: ElevatedButton(
                      onPressed: () async{
                        showDialog(
                          context: context, 
                          builder: (BuildContext context) => AlertDialog(
                          title: const Text("Name of a person"),
                          content:
                            Container(
                              height: 100,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: recipientController,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Full name'
                                    ),
                                  ),  
                                  ValueListenableBuilder(
                                    valueListenable: cn.value.tryb, 
                                    builder: (BuildContext context, bool value, Widget? child){
                                      return !initConv?FadingText(
                                        child: const Text(
                                          "Given  person is  not  registered",
                                          style:TextStyle(
                                            color: Colors.red)),)
                                      :const Text("",style:TextStyle(color: Colors.white));
                                    }
                                  ),                 
                                ]
                              )
                            ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                checkIfNameExists();
                              },
                              child: const Text("ADD"))
                              ,TextButton(
                                onPressed: (){
                                initConv = true;
                                Navigator.of(context).pop();
                              },
                              child: const Text("BACK"))
                            ],
                          )
                        );
                      },
                      child: Icon(Icons.add_outlined),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), //padding: EdgeInsets.all(20)
                        backgroundColor: Colors.teal, // button
                        foregroundColor: Colors.black, //splash
                      )
                    )
                  )
                  )
                ),
          Expanded(
              flex:4,
              child: Container(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ))
                  )),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                onPressed: (){
                  var stop = 1;
                  if(pm.value.tryb.value.key.toString() != FirebaseDatabase.instance.ref().child("emptyQuery").key.toString()){ 
                    var message = {
                      "from": loggedUser["name"],
                      "text": messageController.text
                    };
                    pm.value.tryb.value.push().set(message);
                    FirebaseDatabase.instance.ref().child("users").child(pm.value.tryb.value.parent!.key.toString())
                    .child('conversations').child(userKey).child("messages").push().set(message);
                    messageController.clear();
                  }
                },
              )
            )
        ],
      )
    )
    ],);
  }
}