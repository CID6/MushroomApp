
import  'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_service.dart';
import 'package:flutter_application_1/comment_section.dart';
import 'package:flutter_application_1/create_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_application_1/private_messaging.dart';

DatabaseReference? DB;
Query? posts;
Query? follows;
String userKey = "";
Map loggedUser = {}; 
bool initFollow = true;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  bool loggedIn = false;
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


class  UserNotFound{
  ValueNotifier<bool> trigger = ValueNotifier(false);
  UserNotFound({required this.trigger});
}
class UserNotFoundNotifier extends ValueNotifier<UserNotFound>{
  UserNotFoundNotifier({required UserNotFound value}): super(value);

  void change(bool trigger){
    value.trigger.value = trigger;
    notifyListeners();
  }
}

ConvNotifier cn = ConvNotifier(value: Conv(tryb: ValueNotifier(false)));
UserNotFoundNotifier unfn = UserNotFoundNotifier(value: UserNotFound(trigger: ValueNotifier(false)));
SwitchInforNotifier si = SwitchInforNotifier(value: SwitchInfo(tryb: ValueNotifier(false)));
FollowedModeNotifier fn = FollowedModeNotifier(value: FollowedMode(tryb: ValueNotifier<String>("Posts")));
SwitchNotifier sn =SwitchNotifier(value: Switch(tryb: ValueNotifier<String>("My Profile")));
FollowedUser followedUser = FollowedUser(fakePosts);
PMuserNotifier pm = PMuserNotifier(value: PMuser(tryb: ValueNotifier<DatabaseReference>(FirebaseDatabase.instance.ref().child("emptyQuery"))));


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
      //home:Kolumna4()
      home:LoginPage()//AuthService().handleAuthState(context)

      );
    
  }

}







class LoginPage extends StatefulWidget{
  final bool popUp;
  LoginPage([this.popUp=false]);
  @override
  State<LoginPage> createState() => _LoginPage();
}

  

class _LoginPage extends State<LoginPage>{
  final myLoginController = TextEditingController();
  final myPasswordController = TextEditingController();

  void showAlert(){
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: const  Text('Missing Data'),
        content: const Text('Given person is not registered'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context,"OK"),
            child: const Text("OK"))
        ],
      ));
  }

  @override
  void initState(){
    super.initState();
    if(widget.popUp==true){Future.delayed(Duration.zero, () => showAlert());}
  }

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
                ButtonLogin("Google", "G")
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
                        backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                        
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:5),
                      //child:  Text("@${user.name}")),
                      //child: Text("@name")),
                      child:  Text("@"+FirebaseAuth.instance.currentUser!.displayName!),),
                      
                    Padding(
                      padding: EdgeInsets.only(left: 100),
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
                           
                            AuthService().signOut();
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
  
  void update(String name)async{
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users').child(userKey);
    await ref.update({
      name:widget.editor.text,
    });
  }

  String toUpdate = "";
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        if(widget.mode=="F"){
          toUpdate  = "favMushroom";
          loggedUser['favMushroom'] = widget.editor.text;
          update('favMushroom');
        }
        else if(widget.mode == "D"){
          toUpdate  = "description";
          loggedUser["description"] = widget.editor.text;
          update("description");
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




class FadingText extends StatefulWidget{
  final Widget child;
  FadingText({required  this.child});
  @override
  createState() => FadingTextState();
}


class FadingTextState extends State<FadingText> with SingleTickerProviderStateMixin{
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState(){
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
      );
    _animation = Tween(
      begin: 1.0,
      end: 0.0,
      ).animate(_controller!);
  }
  @override
  dispose(){
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    _controller!.reset();
    _controller!.forward();
    
    
    return FadeTransition(opacity: _animation!,child:widget.child);
  }
}


class Display extends StatefulWidget{
  const Display({super.key});
  @override
  State<Display> createState() => _Display();
  
}


Query _query = FirebaseDatabase.instance.ref().child('users').child(userKey).child('posts');
Key _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
String mode = 'P';

class _Display extends State<Display>{
  final favTextController = TextEditingController();
  final infoTextController = TextEditingController();
  TextEditingController followedName = TextEditingController();
  double opacity = 0.0;
  

  //checkNameFunc
  void checkIfNameExists() async{
    DatabaseEvent event = await FirebaseDatabase.instance.ref().child('users').orderByChild('name').equalTo(followedName.text).once();
    if(event.snapshot.exists){
      final subString = getUid(event.snapshot.value.toString());
      DatabaseEvent secEvent = await FirebaseDatabase.instance.ref().child('users').child(userKey).child('follows').orderByChild('name').equalTo(followedName.text).once();
      if(secEvent.snapshot.exists == false){
        DatabaseReference ref = FirebaseDatabase.instance.ref().child('users')
        .child(userKey).child('follows');
        var followData = {
        'name': followedName.text,
        'rid': subString
        };
        ref.push().set(followData);
        //AddEmptyConvo
      }
      initFollow = true;
      Navigator.of(context).pop();
    }
    else{
      initFollow = false;
      unfn.value.trigger.value = !unfn.value.trigger.value;
    
    }

  }


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
                                hintText: "   ${loggedUser['favMushroom']}",
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
                                hintText: "   ${loggedUser['description']}",
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
        setState(() {
          if(sn.value.tryb.value ==  "My Profile"){
            _query = FirebaseDatabase.instance.ref().child('users').child(userKey).child('posts');
            _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
            mode ='P';
          }
          else{
            _query = FirebaseDatabase.instance.ref().child('users').child(userKey).child('follows');
            _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
            mode  = 'F';
          }
        });

        return Column(
        children: [
          Container(child:
          Expanded(child:
          
          FirebaseAnimatedList(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            query: _query,
            key: _key,
            itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation animation,int index) {
              Map post = snapshot.value as Map;
              post['key'] = snapshot.key;
              post['ukey'] = userKey;
              return Post(post,mode); 
            })
            
          )
        ),
        
         Padding(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
          child: GestureDetector(
            onTap: (){
              if(sn.value.tryb.value == "My Profile"){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => postPage())
              );
              }
              else{
              showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Name of a person"),
                  content:
                  Container(
                    height: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [TextFormField(
                    controller: followedName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Full name'
                    ),
                  ),  
                  ValueListenableBuilder(
                    valueListenable: unfn.value.trigger, 
                    builder: (BuildContext context, bool value, Widget? child){
                      return !initFollow?FadingText(child: Text("Given  person is  not  registered",style:TextStyle(color: Colors.red)),)
                      :Text("",style:TextStyle(color: Colors.white));
                    }
                    ),
                  
                  ])),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        checkIfNameExists();
                        //check if name exists
                      },
                      child: const Text("FOLLOW"))
                      ,TextButton(
                        onPressed: (){
                          initFollow = true;
                          Navigator.of(context).pop();
                        },
                        child: const Text("BACK"))
                  ],
                )
                );
              
              }
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width-100,
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
                child: Text(sn.value.tryb.value=="My Profile"?"Create a Post":"Follow Somebody",
                textAlign: TextAlign.center,)
              ),
            )
          )
        ),
      
      
        ]
          );
      }}
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
  
  void Register() async{
    await AuthService().signInWithGoogle(context);
    
    DatabaseReference? db = FirebaseDatabase.instance.ref().child('users');
    var userData = {
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'favMushroom':'',
      'dateOfBirth':'',
      'description':'',
      // 'posts': {},
      // 'follows': {},
      // 'pms': {},
    };
    db.push().set(userData);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
        )
    );
  }
  
  
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: GestureDetector(
        onTap: (){
          // if(widget.name.text == "" || widget.password == "" || widget.passwordc == ""){
          //   showDialog(
          //       context: context, 
          //       builder: (BuildContext context) => AlertDialog(
          //         title: const Text("ERROR"),
          //         content: const Text("Fill in all the fields"),
          //         actions: <Widget>[
          //           TextButton(
          //             onPressed: () => Navigator.pop(context,"OK"),
          //             child: const Text("OK"))
          //         ],
          //       )
          //       );
          //     return; 
          // }
          // if(widget.password.text != widget.passwordc.text){
          //   showDialog(
          //       context: context, 
          //       builder: (BuildContext context) => AlertDialog(
          //         title: const Text("ERROR"),
          //         content: const Text("Passwords must match"),
          //         actions: <Widget>[
          //           TextButton(
          //             onPressed: () => Navigator.pop(context,"OK"),
          //             child: const Text("OK"))
          //         ],
          //       )
          //       );
          //     return; 
          // }
          //TODO: Registerfunc
          Register();
          


          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => ProfilePage(),
          //       )
          //   );
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
  
  void logIn() async {
    Widget path= await AuthService().signInWithGoogle(context);
    if(path.runtimeType.toString()!="LoginPage"){
      getKey();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => path,
        )
    );
  }

  
  @override
  Widget build(BuildContext context){
    return 
    Padding(
      padding:const EdgeInsets.fromLTRB(0,16,0,16),
      child:GestureDetector(
        
        onTap: (){
          if(widget.mode == 'G'){
         
            logIn();
          }
          else if(widget.mode == "R"){
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

            
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProfilePage(),
            //     )
            // ); 
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
            if(FirebaseAuth.instance.currentUser != null){
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
  final Map post;
  final String mode;
  Post(this.post,this.mode);

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
      widget.mode == "P"?
      Column(
        children: [
             Container(
              width: MediaQuery.of(context).size.width-75,
              decoration: BoxDecoration(
                color: Colors.white
              ),
                child:Row(children:[
                  Expanded(
                  flex:8,
                  child:Text(
                  widget.post['title'],
                  style: TextStyle(
                    fontSize: 20
                  ),
                  ),),
                sn.value.tryb.value == 'My Profile'?Expanded(
                  flex: 1,
                 child: GestureDetector(
                  onTap: (){
                    FirebaseDatabase.instance.ref().child('users').child(userKey).child('posts').child(widget.post['key']).remove();
                  },
                  child: Icon(Icons.delete_outlined),
                )):Text("",style: TextStyle(color:Colors.transparent),)
                ]),
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width-75,
                child: Image.network(
                  widget.post['url'],
                  fit:BoxFit.fill,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-75,
                child: Text(
                  widget.post['description'],
                  style: const TextStyle(
                    fontSize: 20
                  )
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width-75,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommnentSection(
                            title: widget.post["title"],
                            description: widget.post["description"],
                            commentsLink: FirebaseDatabase.instance
                              .ref()
                              .child('users')
                              .child(widget.post['ukey'])
                              .child('posts')
                              .child(widget.post['key'])
                              .child("comments"),
                            imageLink: widget.post["url"],
                          ),
                          )
                      );
                      },
                      icon:const Icon(Icons.add_outlined)),
                      const Text(
                        "Go to comment section"
                      ),
                  ],) 
              )
    
          
        ],
    ):
    FollowUser(widget.post),
    )]));
  }
}

class FollowUser extends StatefulWidget{
  final Map userData;
  FollowUser(this.userData);

  @override
  _FollowUser createState() => _FollowUser();
}

class _FollowUser extends State<FollowUser>{
  Map FUser = {};
  @override
  Widget build(BuildContext context){
    return
    Padding( 
    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
    child:Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
              Container(
              width: MediaQuery.of(context).size.width-40,             
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left:20),
                  child:GestureDetector(
                    onTap: () async{
                      await downloadData(widget.userData['rid']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowedProfile(FUser,widget.userData['rid']),
                          )
                      );
                    },
                    child:Expanded(
                      child: Row(children: [
                    CircleAvatar(backgroundImage: AssetImage("assets/defaultAvatar.jpg"),),
                    Padding(
                      padding: EdgeInsets.only(left:5),
                      child:Text("@${widget.userData['name']}")
                    )
                  ],)),),),
                  Expanded(
                    
                    child: GestureDetector(
                      onTap: (){
                        FirebaseDatabase.instance.ref().child('users').child(userKey).child('follows').child(widget.userData['key']).remove();
                      },
                      child:Padding(padding: EdgeInsets.only(right:10),child:Align(child:Icon(Icons.delete_outlined),
                      alignment: Alignment.centerRight,)
                      )
                      )
                    
                  )
                  
                  
                  // Padding(
                  //   padding: EdgeInsets.only(left:20),
                  //   child: CircleAvatar(
                  //     backgroundImage: AssetImage("assets/defaultAvatar.jpg"),
                  //   )
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(left:5)),
                  //   Text("@${widget.userData['name']}")
                ],
              ),
            )
            
          ]
          )
          );
    
  }
  Future downloadData(String klucz)async{
    final  event = await FirebaseDatabase.instance.ref().child('users').child(klucz).once();
    if(event.snapshot.exists){
      FUser = event.snapshot.value as  Map;
    }  
  }
}

class FollowedProfile extends StatefulWidget{
  final Map mapa;
  final String klucz;
  FollowedProfile(this.mapa,this.klucz);
  @override
  FollowedProfileState createState() => FollowedProfileState();
}

class FollowedProfileState extends State<FollowedProfile>{

  @override
  void initState() {
    super.initState();
  }

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
                      child: Text("@"+widget.mapa['name']),
                    ),
                    Padding(//TODO: fix button padding
                      padding: EdgeInsets.only(left:150),
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
                    Query followQuery = FirebaseDatabase.instance.ref().child('users').child(widget.klucz).child('posts');
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blueAccent,
                      child: fn.value.tryb.value == "Posts"?
                        FirebaseAnimatedList(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          query: followQuery,
                          itemBuilder: (BuildContext context, DataSnapshot  snapshot, Animation animation, int index){
                            Map post = snapshot.value as Map;
                            post['key'] = snapshot.key;
                            post['ukey'] = widget.klucz;
                            return Post(post,"P");
                          },
                        )
                        :Column(
                          children: [
                            //TODO: ScrollView
                            FollowText("Username:","M"),
                            FollowText(widget.mapa['name']),
                            FollowText("Date of Birth:","M"),
                            FollowText(widget.mapa['dateOfBirth']),
                            FollowText("Favourite Mushroom","M"),
                            FollowText(widget.mapa['favMushroom']),
                            FollowText("Description:","M"),
                            FollowText(widget.mapa['description'],"B"),
                            
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





