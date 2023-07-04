import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

import 'main.dart';

class CommnentSection extends StatefulWidget{
  const CommnentSection({
    required this.title,
    required this.description,
    required this.commentsLink,
    required this.imageLink,
  });

  final String description;
  final String title;
  final DatabaseReference commentsLink;
  final String imageLink;
  
  @override
  State<CommnentSection> createState() => _CommnentSection();
}

class _CommnentSection extends State<CommnentSection>{
  
  final commentController = TextEditingController();
  var comment;

  @override
  void dispose(){
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            icon: const Icon(Icons.arrow_back_rounded))
        ],),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all()
            ),
            height: 250,
            width: MediaQuery.of(context).size.width-25,
            child: Image.network(
              widget.imageLink,
              fit:BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width-25,
            child: Align(
              alignment: Alignment.centerLeft,
                child: Text(
                  "Desc: ${widget.description}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
              ),
            ) 
          ), 
          Expanded(
            flex: 4,
            child: FirebaseAnimatedList(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              query: widget.commentsLink,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,Animation animation,int index) {
              Map post = snapshot.value as Map;
              post['key'] = snapshot.key;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(post['avatarUrl']),
                ),
                title: Text("@${post["Username"]}:   ${post["Text"]}"),
                trailing: loggedUser["name"]==post["Text"]?IconButton(
                  onPressed: (){
                    widget.commentsLink.child(post["key"]).remove();
                  }, 
                  icon: const Icon(Icons.delete_outlined)):null,
              ); 
          })
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 10,
                  child: TextField(
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: commentController,
                  )),
                Expanded(
                  flex: 1, 
                  child:  IconButton(
                    icon: const Icon(Icons.email_outlined),
                    onPressed: (){
                      comment = {
                        "Username": loggedUser["name"],
                        "uid": userKey,
                        "Text": commentController.text,
                        "avatarUrl": loggedUser['avatarUrl'].toString().trim(),
                      };
                      widget.commentsLink.push().set(comment);
                      commentController.clear();
                    },
                  ))
              ],)
          ),
        ]),
    );
  }
}