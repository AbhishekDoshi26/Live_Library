import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String enroll;
String sem;
String issuedBooks;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();

  String _password;
  String name;
  String branch;
  String sem;
  String email;

  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    Toast.show("OTP has been sent to your registered number. Please Wait...\n\nIf you don't receive otp, you have been blocked by our server for multiple logins in a day. Please try again after 24 hours", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
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
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15)),
            title: Text('Enter OTP',style: TextStyle(color: Colors.blue)),
            content: Container(
              padding: const EdgeInsets.only(left:15.0,right: 15),
              height: 85,
              child: Column(children: [
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 10),),
                (errorMessage != '' ? Text(errorMessage, style: TextStyle(color: Colors.red),) : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                      Toast.show("You have successfully signed in", context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
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
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
      Toast.show("You have successfully signed in", context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
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
          errorMessage = 'You have been blocked by our server for multiple logins in a day. Please try again after 24 hours';
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

  void submit() async {
    if (_formKey.currentState.validate()) {
      print(enroll);
      DocumentReference documentReference = Firestore.instance.collection("Users").document(enroll);
      documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          if (_password == datasnapshot.data['Password'].toString()) {
            branch = datasnapshot.data['Branch'].toString();
            phoneNo = datasnapshot.data['Phone Number'].toString();
            name = datasnapshot.data['Name'].toString();
            sem = datasnapshot.data['Semester'].toString();
            email = datasnapshot.data["Email Id"].toString();
            issuedBooks = datasnapshot.data["Issued Books"].toString();
            verifyPhone();
          }
          else
            Toast.show("Invalid Password!!!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        }
        else
          Toast.show("User not registered!!!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("assets/abstract_bg.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 105,
                width: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(2.0, 4.0),
                        blurRadius: 8),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                  child: Image.asset('assets/logo.jpg'),
                ),
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
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Enrollment No is required';
                            if (value.length < 12)
                              return 'It should be of 12 digits ';
                            return null;
                          },
                          onChanged: (String value) {
                            enroll = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Enrollment Number',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          validator: (String value) {
                            if (value.isEmpty) return 'Password is required';
                            if (value.length < 8)
                              return 'Password should be of more than 8 characters';
                            return null;
                          },
                          onChanged: (String value) {
                            _password = value;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              suffixIcon: IconButton(
                                  icon: _isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  onPressed: _toggleVisibility)),
                          keyboardType: TextInputType.text,
                          obscureText: _isHidden,
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 5),
                          alignment: Alignment(1, 0),
                          child: FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.pushNamed(context, '/confirmuserpage');
                            },
                            child: Text('Forgot Password?',
                                style: TextStyle(
                                    color: Colors.tealAccent,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                          minWidth: 300,
                          color: Colors.blue,
                          textColor: Colors.black,
                          child: Text('LOG IN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          onPressed: submit,
                          splashColor: Colors.blue,
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                            minWidth: 300,
                            color: Colors.blue,
                            textColor: Colors.black,
                            child: Text('REGISTER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/signuppage');
                            },
                            splashColor: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
