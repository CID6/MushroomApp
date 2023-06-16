import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'package:instant/instant.dart';
import 'package:firebase_auth/firebase_auth.dart';

class postPage extends StatefulWidget{
  @override
  State<postPage> createState() => _postPage(); 
}

class _postPage extends State<postPage>{
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  var  Post = null;
  DatabaseReference? dbRef;

  


  @override
  void initState() {
    super.initState();
    dbRef = DB!;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: Text("Create a Post")),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              child: file == null
                  ? IconButton(onPressed: (){
                    getImage();
                  }, icon: Icon(
                    Icons.add_a_photo,
                    size: 90,
                    color: Color.fromARGB(255, 0, 0, 0),
                  )
                  ):
                  MaterialButton(
                    onPressed: (){
                      getImage();
                    },
                    height: 100,
                    child: Image.file(
                      file!,
                      fit: BoxFit.fill
                    ),
                  )
            ),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: title,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'title'
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: description,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'description'
            ),
          ),
          SizedBox(height: 20,),
          MaterialButton(
            height: 40,
            onPressed: () {
              if(file!=null){
                uploadFile();
              }
            },
            child: Text(
              "Upload",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
              ),
            ),
            color: Colors.indigo[900],
          ),
          SizedBox(height: 10,),
          MaterialButton(
            height: 40,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
              ),
            ),
            color: Colors.indigo[900],
          ),
        ],
      )
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async{
    try{
      var imageFile = FirebaseStorage.instance
        .ref()
        .child('user_photos')
        .child('/${title.text}');
      UploadTask task = imageFile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null){
        DateTime currentTime = DateTime.now();
        Post = {
          'title' : title.text,
          'description': description.text,
          'url': url,
          'date': dateTimeToZone(zone: 'CEST', datetime: currentTime).toString().substring(0,19),
        };
      }
      dbRef!.push().set(Post).whenComplete((){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
      builder: (context)=> ProfilePage()));});
      
      

    } on Exception catch (e){
      print(e);
    }
  }
}
