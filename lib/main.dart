import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:livelibrary/change_password.dart';
import 'package:livelibrary/confirm_user.dart';
import 'package:livelibrary/display_books.dart';
import 'package:livelibrary/login.dart';
import 'package:livelibrary/sign_up.dart';
import 'dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => new ThemeData(
              primaryColor: Colors.blue,
              accentColor: Colors.blueAccent,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Live Library',
            theme: theme,
            home: LoginPage(),
            routes: <String, WidgetBuilder>{
        '/loginpage': (BuildContext context) => LoginPage(),
        '/signuppage': (BuildContext context) => SignUpPage(),
        '/homepage': (BuildContext context) => Dashboard(),
        '/confirmuserpage': (BuildContext context) => ConfirmUser(),
        '/cangepasswordpage': (BuildContext context) => ChangePassword(),
        '/displaybooks': (BuildContext context) => DisplayBooks(),
      },
          );
        });
  }
}
