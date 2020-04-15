import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
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
            // darkTheme: ThemeData.dark().copyWith(
            //   primaryColor: Colors.blue,
            //   accentColor: Colors.blueAccent,
            // ),
            theme: theme,
            home: Dashboard(),
          );
        });
  }
}
