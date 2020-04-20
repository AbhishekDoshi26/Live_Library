import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:livelibrary/display_books.dart';
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
            home: Dashboard(),
            routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => Dashboard(),
        // '/loginpage': (BuildContext context) => MyApp(),
        '/displaybooks': (BuildContext context) => DisplayBooks(),
      },
          );
        });
  }
}
