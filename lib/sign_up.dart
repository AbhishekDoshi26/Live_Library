import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _password = new TextEditingController();
  TextEditingController _conpassword = new TextEditingController();

  String _name;
  String _phone;
  String _email;
  String _enrollment;
  String _branch;
  String _semester;
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;

  bool _isHide = true;

  void _toggleVisible() {
    setState(() {
      _isHide = !_isHide;
    });
  }

  Future<void> verifyPhone() async {
    Toast.show(
        "OTP has been sent to your registered number. Please Wait...\n\nIf you don't receive otp, you have been blocked by our server for multiple logins in a day. Please try again after 24 hours",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP);
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text('Enter OTP', style: TextStyle(color: Colors.blue)),
            content: Container(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              height: 85,
              child: Column(children: [
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) async {
                    if (user != null) {
                      Map<String, dynamic> data = <String, dynamic>{
                        "Name": _name,
                        "Enrollment No": _enrollment,
                        "Email Id": _email,
                        "Password": _password.text,
                        "Phone Number": _phone,
                        "Branch": _branch,
                        "Semester": _semester,
                        "Issued Books": Random().nextInt(50),
                        "Registered On": Timestamp.now(),
                      };
                      await db
                          .collection("Users")
                          .document(_enrollment)
                          .setData(data)
                          .whenComplete(() {
                        print("Form Added");
                      }).catchError((e) => print(e));
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/loginpage');
                      Toast.show("You have successfully registered", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      FirebaseAuth.instance.signOut();
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Map<String, dynamic> data = <String, dynamic>{
        "Name": _name,
        "Enrollment No": _enrollment,
        "Email Id": _email,
        "Password": _password.text,
        "Phone Number": _phone,
        "Branch": _branch,
        "Semester": _semester,
        "Issued Books": Random().nextInt(50),
        "Registered On": Timestamp.now(),
      };
      await db
          .collection("Users")
          .document(_enrollment)
          .setData(data)
          .whenComplete(() {
        print("Form Added");
      }).catchError((e) => print(e));
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/loginpage');
      Toast.show("You have successfully registered", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      FirebaseAuth.instance.signOut();
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid OTP';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      case 'We have blocked all requests from this device due to unusual activity. Try again later.':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage =
              'You have been blocked by our server for multiple logins in a day. Please try again after 24 hours';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });
        break;
    }
  }

  @override
  initState() {
    super.initState();
    auth.onAuthStateChanged.listen((u) {
      setState(() => user = u);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 8,
        title: new Text("Sign Up"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Image(
          image: AssetImage("assets/abstract_bg.jpg"),
          fit: BoxFit.fill,
          color: Colors.black54,
          colorBlendMode: BlendMode.darken,
        ),
        Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.blue,
              accentColor: Colors.blueAccent,
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(fontSize: 20.0),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 105),
                    buildNameField(),
                    SizedBox(height: 18),
                    buildEnrollmentField(),
                    SizedBox(height: 18),
                    buildEmailField(),
                    SizedBox(height: 18),
                    buildPhoneField(),
                    SizedBox(height: 18),
                    buildBranchField(),
                    SizedBox(height: 18),
                    buildSemesterField(),
                    SizedBox(height: 18),
                    buildPasswordField(),
                    SizedBox(height: 18),
                    buildConfirmPasswordField(),
                    SizedBox(height: 20),
                    MaterialButton(
                      height: 48,
                      minWidth: 319,
                      color: Colors.blue,
                      textColor: Colors.black,
                      child: Text('SIGN UP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          phoneNo = _phone;
                          verifyPhone();
                        }
                      },
                      splashColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildEmailField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Email is required';
          if (!RegExp(
                  r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
              .hasMatch(value)) return 'Please enter a valid email';
          return null;
        },
        onChanged: (String value) {
          _email = value;
        },
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.email,
          ),
        ),
      ),
    );
  }

  Widget buildPhoneField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Phone no is required';
          // if (value.length > 10) return 'please enter correct mobile no';
          return null;
        },
        onChanged: (String value) {
          _phone = value;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Phone',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.phone,
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Name is required';
          return null;
        },
        onChanged: (String value) {
          _name = value;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Full Name',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.person,
          ),
        ),
      ),
    );
  }

  Widget buildEnrollmentField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Enrollment No is required';
          if (value.length < 12) return 'It should be of 12 digits ';
          return null;
        },
        onChanged: (String value) {
          _enrollment = value;
        },
        keyboardType: TextInputType.number,
        style: TextStyle(),
        decoration: InputDecoration(
          labelText: 'Enrollment No',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.person_outline,
          ),
        ),
      ),
    );
  }

  Widget buildBranchField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Branch is required';
          return null;
        },
        onChanged: (String value) {
          _branch = value;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Branch',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.reorder,
          ),
        ),
      ),
    );
  }

  Widget buildSemesterField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Semester is required';
          if (value.length > 1) return 'Please enter correct Semester';
          return null;
        },
        onChanged: (String value) {
          _semester = value;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Semester',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.reorder,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty) return 'Password is required';
          if (value.length < 8)
            return 'Password should be of more than 8 characters';
          return null;
        },
        controller: _password,
        keyboardType: TextInputType.text,
        obscureText: _isHide,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Color(0xffffff))),
          prefixIcon: Icon(
            Icons.lock,
          ),
          suffixIcon: IconButton(
              icon: _isHide
                  ? Icon(
                      Icons.visibility_off,
                    )
                  : Icon(
                      Icons.visibility,
                    ),
              onPressed: _toggleVisible),
        ),
      ),
    );
  }

  Widget buildConfirmPasswordField() {
    return Container(
      height: 55,
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty)
            return 'Reenter the password';
          else if (value != _password.text)
            return 'Password doesn\'t match';
          return null;
        },
        controller: _conpassword,
        keyboardType: TextInputType.text,
        obscureText: _isHide,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            Icons.lock,
          ),
          suffixIcon: IconButton(
              icon: _isHide
                  ? Icon(
                      Icons.visibility_off,
                    )
                  : Icon(
                      Icons.visibility,
                    ),
              onPressed: _toggleVisible),
        ),
      ),
    );
  }
}
