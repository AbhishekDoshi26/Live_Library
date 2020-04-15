import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Library',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        accentColor: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}
