import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Comment{
  String? name;
  String? value;
  Comment(this.name,this.value);
}

class PostData{
  Image? picture;
  String? title;
  String? description;
  List<Comment> comments = List.empty();
  PostData(this.title,this.description,this.comments);
}

class Message{
  String sender = "";
  String msg = "";
  Message(this.sender,this.msg);
}

class PM{
  String who = "";
  List<Message> conversation = List.empty();
  PM(this.conversation,this.who);
}

class User{
  bool loggedIn = true;
  Image? avatar; //???
  String? fav ="Toadstool";
  String? name = "Username";
  String? dateOfBirth = "01.01.2023";
  String? description = "Mushroom guy";
  List<PostData> myPosts = List.empty();
  int? id;
  List<String> follows = List.empty();
  List<PM> pms = List.empty();
  User(this.myPosts,this.follows,this.pms);
}

class FollowedUser{
  Image? avatar; //???
  String name = "";
  String dateOfBirth = "01.01.2023";
  String description = "Description";
  List<PostData> posts= List.empty();
  int? id;
  FollowedUser(this.posts);
}

class AppInfo{
  String currentPage = "Picture";
}

class Switch{
  ValueNotifier<String> tryb = ValueNotifier("My Profile");
 
  Switch({required this.tryb});
}

class SwitchNotifier extends ValueNotifier<Switch>{
  SwitchNotifier({required Switch value}) : super(value);

  void change(String tryb){
    if(value.tryb.value!=tryb){
      value.tryb.value = tryb;
      notifyListeners();
    }
  }
}

class SwitchInfo{
  ValueNotifier<bool> tryb = ValueNotifier(false);
  SwitchInfo({required this.tryb});
}
class SwitchInforNotifier extends ValueNotifier<SwitchInfo>{
  SwitchInforNotifier({required SwitchInfo value}): super(value);
  void change(bool tryb){
    value.tryb.value = !value.tryb.value;
    notifyListeners();
  }
}

class FollowedMode{
  ValueNotifier<String> tryb = ValueNotifier("Posts");
  FollowedMode({required this.tryb});
}
class FollowedModeNotifier extends ValueNotifier<FollowedMode>{
  FollowedModeNotifier({required FollowedMode value}): super(value);

  void change(String tryb){
    if(value.tryb.value != tryb){
      value.tryb.value = tryb;
      notifyListeners();
    }
  }
}

class PMuser{
  ValueNotifier<String> tryb = ValueNotifier(user.pms[0].who);
  PMuser({required this.tryb});
}
class PMuserNotifier extends ValueNotifier<PMuser>{
  PMuserNotifier({required PMuser value}): super(value);

  void change(String tryb){
    if(value.tryb.value!=tryb){
      value.tryb.value = tryb;
      notifyListeners();
    }
  }
}

SwitchInforNotifier si = SwitchInforNotifier(value: SwitchInfo(tryb: ValueNotifier(false)));
FollowedModeNotifier fn = FollowedModeNotifier(value: FollowedMode(tryb: ValueNotifier<String>("Posts")));
SwitchNotifier sn =SwitchNotifier(value: Switch(tryb: ValueNotifier<String>("My Profile")));
FollowedUser followedUser = FollowedUser(fakePosts);
PMuserNotifier pm = PMuserNotifier(value: PMuser(tryb: ValueNotifier<String>(user.pms[0].who)));


AppInfo appInfo = AppInfo();
var fakeComments = <Comment>[Comment("User1","Great Photo"),Comment("User2","Good Photo"),Comment("User3","Nice Photo"),];
var fakePostData = PostData("Mushroom", "About Mushroom",fakeComments);
var fakePosts = <PostData>[fakePostData,fakePostData,fakePostData];
var PMS = <PM>[PM(<Message>[Message("User1","hello"),Message("Username", "hey"),Message("Username", "!")],"User1"),PM(<Message>[Message("User2","Hello"),Message("Username", "Hey")],"User2")];
User user = User(fakePosts,<String>["User1","User2","User3","User4","User5",],PMS);
var underline = "My Profile";

class MyApp extends StatelessWidget {

  String napis = "Hello";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Kolumna4()
      );
    
  }

}







class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}


class _LoginPage extends State<LoginPage>{
  final myLoginController = TextEditingController();
  final myPasswordController = TextEditingController();

  @override
  void dispose(){
    myLoginController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return 
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/forest2.jpg"),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("data")
        ),
        body: Column(
          children: [
            Row(children: [
              Expanded(child: ButtonWidget("Picture","P")),
              Expanded(child: ButtonWidget("Social","S")),
            ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                 padding:const EdgeInsets.fromLTRB(0, 100, 0, 16), // TODO: change TOP with phone res
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        controller: myLoginController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: "Username",
                )))),
                Padding(
                 padding:const EdgeInsets.fromLTRB(0, 16, 0, 16), // TODO: change TOP with phone res
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        controller: myPasswordController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: "Password",
                )))),
                ButtonLogin("Log in","PR",myLoginController,myPasswordController),
                ButtonLogin("Register","R"),
              ],
            )
        ]),
      ));
  }
}


class ProfilePage extends StatelessWidget{
  

  @override
  Widget build(BuildContext context){
    List<String> items = ["Log out","Edit profile"];
    String? selected = "";
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("data"),
        ),
        body:Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(child: ButtonWidget("Picture","P")),
                  Expanded(child: ButtonWidget("Social","S"))
                ],
              ),
            ),
            Expanded(
              flex:1,
              child: Container(
                color: Colors.purpleAccent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left:20),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/defaultAvatar.jpg"),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:5),
                      child:  Text("@${user.name}")),
                      
                    Padding(
                      padding: EdgeInsets.only(left: 175),
                      child: PopupMenuButton(
                        icon: Icon(Icons.settings, color: Colors.white),
                        
                        itemBuilder: (context) =>[
                          PopupMenuItem(
                            child: Text("Log out"),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text("Edit Profile"),
                            value: 2,
                            )
                        ],
                        onSelected: (int newValue){
                          if(newValue == 1){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                                )
                            );
                          }
                          else{
                            sn.value.tryb.value = "Edit";
                          }
                        },
                      )
                    )
                  ],)
              )

            ),
            Expanded(
              flex: 1,
              child: Container(
                child: ValueListenableBuilder(
                  valueListenable: sn.value.tryb,
                  builder: (BuildContext contex, String value, Widget? child){
                    return Row(
                      children: [
                        Expanded(child: ProfileButton("Follows")),
                        Expanded(child: ProfileButton("My Profile")),
                        Expanded(child: ProfileButton("PMs")),
                      ],
                    );
                  }
                )
              ),
            ),
            Expanded(
              flex: 10,
              child: ValueListenableBuilder(
                valueListenable: sn.value.tryb,
                builder: (BuildContext context, String value, Widget? child){
                return Container(
                  child: Display(),
                  color: Colors.blueAccent,
                  );
                }
                )
            )
            
          ],
        )
      ),
    );
  }
}

class InfoButton extends StatefulWidget{
  final String name;
  final String mode;
  final TextEditingController editor;
  InfoButton(this.name,this.mode,this.editor);
  @override
  _InfoButton createState() => _InfoButton(); 
}

class _InfoButton extends State<InfoButton>{
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        if(widget.mode=="F"){
          user.fav = widget.editor.text;
        }
        else if(widget.mode == "D"){
          user.description = widget.editor.text;
        }
        si.value.tryb.value = true;
      },
      child: Text(
        "  ${widget.name}",
        style: TextStyle(
          fontSize: 20
        ),
        textAlign: TextAlign.left,
      )
    );
  }
}

class Display extends StatefulWidget{
  const Display({super.key});
  @override
  State<Display> createState() => _Display();
  
}

class _Display extends State<Display>{
  final favTextController = TextEditingController();
  final infoTextController = TextEditingController();

  @override
  void dispose(){
    favTextController.dispose();
    infoTextController.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context){
    switch(sn.value.tryb.value){
      case "PMs":{
        return PMPage();
      }
      case "Edit":{
        return 
        Row( 
          children:[
            Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top:10,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: Text(
                          "Edit my profile",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20
                          )
                        )
                      )
                    )
                  ]
                ),
                Row(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top:20,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: Text(
                          "  Favourite Mushroom:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20
                          )
                        )
                      )
                    )
                  ]
                ),
                Row(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top:10,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: si.value.tryb,
                          builder: (BuildContext context, bool value, Widget? child){
                            return TextField(
                              controller: favTextController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                hintText: "   ${user.fav}",
                              ),
                            );
                          }
                        )
                      )
                    ), 
                  ]
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: InfoButton("Send", "F", favTextController)
                      )
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top:20,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: Text(
                          "  About Me:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20
                          )
                        )
                      )
                    )
                  ]
                ),
                Row(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(top:10,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: si.value.tryb,
                          builder: (BuildContext context, bool value, Widget? child){
                            return TextField(
                              controller: infoTextController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                hintText: "   ${user.description}",
                              ),
                            );
                        }
                        )
                      )
                    ), 
                  ]
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10,left:50),
                      child: Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: InfoButton("Send", "D", infoTextController)
                      )
                    )
                  ],
                ),
              ]
            )
          ]
        );
      }
      default: {
        return ListView(
          children: [
            if(sn.value.tryb.value == "My Profile") for(int i = 0; i < user.myPosts.length; i++)Post(user.myPosts[i].title,user.myPosts[i].description,user.myPosts[i].comments)
            else if(sn.value.tryb.value == "Follows") for(int i = 0; i < user.follows.length; i++) FollowUser(user.follows[i])
          ]
        );
      }
    }
  }
}

//
class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPage();
}


class _RegisterPage extends State<RegisterPage>{
  final NameController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmController = TextEditingController();

  @override
  void dispose(){
    NameController.dispose();
    PasswordController.dispose();
    ConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return  Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/shrooms.jpg"),
          fit: BoxFit.cover,

        )
      ),
      child:Scaffold(
        appBar: AppBar(
          title: Text("data"),
        ),
        backgroundColor: Colors.transparent,
      body:Column(
        
        
        children:[
      Row(
              children: [
              Expanded(child: ButtonWidget("Picture","P")),
              Expanded(child: ButtonWidget("Social","S")),
       ]),   
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:const EdgeInsets.fromLTRB(0, 100, 0, 16), // TODO: change TOP with phone res
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              child: TextField(
                controller: NameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: "Username",
                )
              ),
              ),
            )
            ,Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                child: TextField(
                  controller: PasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: "Password",
                  ),
                )
              )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Container(
                  width: MediaQuery.of(context).size.width-100,
                  child: TextField(
                    controller: ConfirmController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Confirm Password",
                    ),
                  ),
                )
                )
              ,RegisterButton(NameController, PasswordController, ConfirmController)
              ,BackButton()
            ],
      ),

     
    ])));
   
  }
}
//


class Kolumna4 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
     body:Column(children: [
    Row(children: [
      Expanded(child: ButtonWidget("Picture","P")),
      Expanded(child: ButtonWidget("Social","S"),),
      ]),
    Expanded(child: 
    Column(
      children: [
        Icon(
          Icons.camera_alt_rounded,
          size: 100,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ))],));
  }
}




class RegisterButton extends StatefulWidget{
  final TextEditingController name;
  final TextEditingController password;
  final TextEditingController passwordc;
  RegisterButton(this.name,this.password,this.passwordc);

  @override
  _RegisterButton createState() => _RegisterButton();
}

class _RegisterButton extends State<RegisterButton>{
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: GestureDetector(
        onTap: (){
          if(widget.name.text == "" || widget.password == "" || widget.passwordc == ""){
            showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("ERROR"),
                  content: const Text("Fill in all the fields"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context,"OK"),
                      child: const Text("OK"))
                  ],
                )
                );
              return; 
          }
          if(widget.password.text != widget.passwordc.text){
            showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("ERROR"),
                  content: const Text("Passwords must match"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context,"OK"),
                      child: const Text("OK"))
                  ],
                )
                );
              return; 
          }
          //TODO: Registerfunc
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
                )
            );
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child:const Align(
            alignment: Alignment.center,
            child: Text(
              "Register",
              textAlign: TextAlign.center,
              )
            )
          )
      )
      
    );
  }
}

class BackButton extends StatefulWidget{
  const BackButton();
  @override
  _BackButton createState() => _BackButton();
}
class _BackButton extends State<BackButton>{
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Go Back",
              textAlign: TextAlign.center,
              )
            )
          ),
      )
    );
  }
}

class ButtonLogin extends StatefulWidget{
  final String name;
  final String mode;
  final TextEditingController? Usercontroller;
  final TextEditingController? Passwordcontroller;
  ButtonLogin(this.name,this.mode,[this.Usercontroller,this.Passwordcontroller]);

  @override
  _ButtonLogin createState() => _ButtonLogin();
}

class _ButtonLogin extends State<ButtonLogin>{
  @override
  Widget build(BuildContext context){
    return 
    Padding(
      padding:const EdgeInsets.fromLTRB(0,16,0,16),
      child:GestureDetector(
        
        onTap: (){
          if(widget.mode == "R"){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPage(),
                )
            );
          }
          else{
            //loginFunc
            if(widget.Usercontroller?.text == "" || widget.Passwordcontroller?.text == ""){
              showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("ERROR"),
                  content: const Text("Fill in all the fields"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context,"OK"),
                      child: const Text("OK"))
                  ],
                )
                );
                return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
                )
            ); 
          }
        },
        
          child: Container(
            
          height: 50,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '${widget.name}',
              textAlign: TextAlign.center,
              )
            )
          )
      ));
  }
  }



  
class ButtonWidget extends StatefulWidget{
  final String name;
  final String mode;
  ButtonWidget(this.name,this.mode);
  
  
  @override
  _ButtonWidget createState() => _ButtonWidget();
} 



class _ButtonWidget extends State<ButtonWidget>{
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        
        setState(() {
          if(widget.mode=="S"){
            // if(appInfo.currentPage=="Social"){
            //   return;
            // }
            // appInfo.currentPage = "Social";
            var destination;
            if(user.loggedIn){
              destination = ProfilePage();
            }
            else{
              destination = LoginPage(); 
            }
            
            
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => destination,
                )
            );
          }
          else if(widget.mode=="P"){
            // if(appInfo.currentPage=="Picture"){
            //   return;
            // }
            // appInfo.currentPage=="Picture";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Kolumna4(),
                )
            );
          }
        }); 
      },
      child: Container(
        height:50,
        child:Align(
          alignment: Alignment.center,
          child:Text(
            '${widget.name}',
            textAlign: TextAlign.center)
            ),
          decoration: BoxDecoration(
            color:Colors.white,
            border: Border.all(
              color: Colors.blue,
              width: 2)
            ),
          ),
    );
  }
} 

class ProfileButton extends StatefulWidget{
  final String name;
  ProfileButton(this.name);

  @override
  _ProfileButton createState() => _ProfileButton();
}

class _ProfileButton extends State<ProfileButton>{
  @override
  Widget build(BuildContext context){
    
    return GestureDetector(
      onTap: (){
        
        var button;
        if(widget.name=="My Profile"){
          button = "My Profile";
        }
        else if(widget.name == "PMs"){
          button = "PMs";
        }
        else{
          button = "Follows";
        }
        setState(() {
          sn.value.tryb.value = button;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '${widget.name}',
            textAlign: TextAlign.center,
            style: widget.name == sn.value.tryb.value?TextStyle(
              decoration: TextDecoration.underline
            ): null
          ),
        ),
      ),
    );
  }
}

class Post extends StatefulWidget{
  final String? title;
  final AssetImage image = AssetImage("assets/shrooms.jpg");
  final String? description;
  List<Comment> comments;
  Post(this.title,this.description,this.comments);

  @override
  _Post createState() => _Post();
}

class _Post extends State<Post>{
  @override
  Widget build(BuildContext context){
    return
    Padding(
      padding: EdgeInsets.only(top: 10),
      child:Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Container(
       
      
      width: MediaQuery.of(context).size.width-25,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 145, 142, 133),
        border: Border.all(
          width: 5,
          color: Colors.red,
        )
      ),
      child:
      Column(
        children: [
          
           //alignment: index.isEven ? Alignment.centerLeft : Alignment.centerRight,
             
             Container(
              width: MediaQuery.of(context).size.width-75,
              decoration: BoxDecoration(
                color: Colors.white
              ),
                child:Text(
                '${widget.title}',
                style: TextStyle(
                  fontSize: 20
                ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-75,
                child:Image.asset("assets/forest.jpg",fit: BoxFit.fill,),
              ),
              Container(
                width: MediaQuery.of(context).size.width-75,

                child: Text(
                  "${widget.description}",
                  style: TextStyle(
                    fontSize: 20
                  )
                )
              ),
             Container(
              child: Padding(padding: EdgeInsets.fromLTRB(25, 10, 0, 0),child:ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.comments.length,
                itemBuilder: (context, index){
                  return Text("${widget.comments[index].name}: ${widget.comments[index].value}");
                },
              )
             ))
          
        ],
    ))]));
  }
}

class FollowUser extends StatefulWidget{
  final String name;
  FollowUser(this.name);

  @override
  _FollowUser createState() => _FollowUser();
}

class _FollowUser extends State<FollowUser>{
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(

              onTap: () {
                //Get userData
                
                setState(() {
                  followedUser.name = widget.name;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FollowedProfile(),
                    )
                );
              },

              child:Container(
              width: MediaQuery.of(context).size.width-25,
              color: Colors.white,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:20),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/defaultAvatar.jpg"),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:5)),
                    Text("@${widget.name}")
                ],
              ),
            )
            )
          ],)
    );
  }
}


class FollowedProfile extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("data"),
        ),
        body: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(child: ButtonWidget("Picture","P")),
                  Expanded(child: ButtonWidget("Social","S"))
                ],
              ),    
            ),
            Expanded(
              flex:1,
              child: Container(
                color: Colors.purpleAccent,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/defaultAvatar.jpg"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:5),
                      child: Text("${followedUser.name}"),
                    ),
                    Padding(//TODO: fix button padding
                      padding: EdgeInsets.only(left:200),
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex:1,
              child: Container(
                child: ValueListenableBuilder(
                  valueListenable: fn.value.tryb,
                  builder: (BuildContext context, String value, Widget? child){
                    return Row(
                      children: [
                        Expanded(child: FollowedButton("Posts")),
                        Expanded(child: FollowedButton("Info")),
                      ],
                    );
                  }
              ),
            ),
            ),
            Expanded(
              flex:8,
              child: Container(
                child: ValueListenableBuilder(
                  valueListenable: fn.value.tryb,
                  builder: (BuildContext context, String value, Widget? child){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueAccent,
                      child: fn.value.tryb.value == "Posts"?
                        ListView(
                          children: [
                            for(int i=0;i<followedUser.posts.length;i++)Post(followedUser.posts[i].title,followedUser.posts[i].description,followedUser.posts[i].comments),
                          ],
                        ):Column(
                          children: [
                            FollowText("Username:","M"),
                            FollowText(followedUser.name),
                            FollowText("Date of Birth:","M"),
                            FollowText(followedUser.dateOfBirth),
                            FollowText("Description:","M"),
                            FollowText(followedUser.description,"B"),
                          ],),
                    );
                  },
                ),
              )
            )
          ],
        )
      ),
    );
  }
}

class FollowText extends StatelessWidget{
  final String name;
  final String? align;
  final String? big;
  FollowText(this.name,[this.align,this.big]);
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child:Container(
            width: MediaQuery.of(context).size.width -100,
            height:big!="B"?35:200,
        
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: Colors.black,
              )
            ),
              alignment: align=="M"?Alignment.center:null,
              child:Text(
              name,
     )),
    );
  }
}

class FollowedButton extends StatefulWidget{
  final String name;
  FollowedButton(this.name);
  @override
  _FollowedButton createState() => _FollowedButton();
}

class _FollowedButton extends State<FollowedButton>{
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        var mode;
        if(widget.name == "Posts"){
          mode = "Posts";
        }
        else{
          mode = "Info";
        }
        setState(() {
          fn.value.tryb.value = mode;
        });
      },
      child: Container(
        color: Colors.white,
        child:Align(
          alignment: Alignment.center,
          child:Text(
            "${widget.name}",
            style: widget.name == fn.value.tryb.value ?
            TextStyle(
              decoration: TextDecoration.underline
              ) : null,
            textAlign: TextAlign.center,
          ),
        )
      )
    );
  }
}




class PMPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    
    return Row(
      children: [
        Expanded(
          flex:1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.black,
                  width: 1
                )
              )
            ),
            //TODO: rebuild on refresh
            child: ListView(
              children: [
                for(int i=0;i<user.pms.length;i++) GestureDetector(
                  onTap: (){
                    
                    pm.value.tryb.value = user.pms[i].who;
                  
                    
                  },
                  child:Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child:Container(
                      child:Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/defaultAvatar.jpg"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left:5),
                            child: Text("@${user.pms[i].who}")
                          )
                        ],
                      )
                    )
                  )
                ),
              ],
            )
          )
        ),
        Expanded(
          flex:2,
          child: Container(
            child: 
              ValueListenableBuilder(
                valueListenable: pm.value.tryb,
                builder: (BuildContext context, String value, Widget? child){
                  print(pm.value.tryb.value);
                  var lista = user.pms[user.pms.indexWhere((element) => element.who == pm.value.tryb.value)];
                  return ListView(
                    children: [    
                      for(int i=0; i<lista.conversation.length;i++) 
                      Padding(
                        padding: EdgeInsets.only(top:10),
                        child:Row(
                          mainAxisAlignment: lista.conversation[i].sender == user.name? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:lista.conversation[i].sender == user.name?0:5,right:lista.conversation[i].sender == user.name?5:0),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 42, 3, 150),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "  ${lista.conversation[i].msg}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  )
                              )
                          )
                          ]
                        )
                        )
                    ]
                  
                  );
                },
              ),
          ),
        )
      ],
    );
  }
}
