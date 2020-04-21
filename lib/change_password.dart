import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livelibrary/confirm_user.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ChangePasswordstate createState() => new _ChangePasswordstate();
}

class _ChangePasswordstate extends State<ChangePassword> {
  final db=Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;

  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  TextEditingController _conpassword = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    auth.onAuthStateChanged.listen((u) {
      setState(() => user = u);
    });
  }


  void submit()  async{
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String,String> data = <String,String>{
        "Password": _password.text,
      };
      await db.collection("Users").document(en).updateData(data).whenComplete(() {
        print("Password Updated");
      }).catchError((e) => print(e));
      Toast.show("Password Updated Successfully", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 8,
        title: new Text("Change Password"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/abstract_bg.jpg"),
            fit: BoxFit.fill,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 85),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                child: Form(key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      brightness: Brightness.dark,
                      accentColor: Colors.blueAccent,
                      primaryColor: Colors.blue,
                      inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 50),
                        ),
                        TextFormField(
                          autofocus: false,
                          obscureText: _isHidden,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(prefixIcon: Icon(Icons.lock),hintText: 'Choose strong password',
                            labelText: 'Password',
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            suffixIcon: IconButton(
                                  icon: _isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: _toggleVisibility)
                          ),
                          validator: (value){
                            if(value.isEmpty)
                              return 'Please enter Password';
                            return null;
                          },
                          controller: _password,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                        TextFormField(
                          autofocus: false,
                          obscureText: _isHidden,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(prefixIcon: Icon(Icons.lock),hintText: 'Same as password',
                            labelText: 'Confirm Password',
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            suffixIcon: IconButton(
                                  icon: _isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: _toggleVisibility)
                          ),
                          validator: (value){
                            if(value.isEmpty)
                              return 'Please enter Password';
                            else if(value != _password.text)
                              return 'Password must be same!!!';
                            return null;
                          },
                          controller: _conpassword,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 50),
                          child: new MaterialButton(
                            height: 60,
                            minWidth: 200,
                            color: Colors.white,
                            textColor: Colors.blueAccent,
                            child: Text('Change Password', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20,)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            splashColor: Colors.white12,
                            onPressed: submit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}