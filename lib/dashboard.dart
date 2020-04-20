import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livelibrary/get_issued_books.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

double n_issued_books = 0;
Map<String, double> dataMap = Map();

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
//  Map<String, double> dataMap = Map();
  List<Color> colorList = [Colors.red, Colors.blue];

  void initState() {
    super.initState();
    dataMap.putIfAbsent("Issued Books", () => n_issued_books);
    dataMap.putIfAbsent("Returned Books", () => 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        leading: Icon(Icons.home),
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
              tooltip: 'Recommended Books',
              icon: FaIcon(FontAwesomeIcons.book),
              onPressed: () {
                Navigator.pushNamed(context, '/displaybooks');
              }),
          IconButton(
              tooltip: 'Change Theme',
              icon: Icon(Icons.brightness_medium),
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
              }),
          IconButton(
              tooltip: 'Log Out',
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
              onPressed: () {
                exit(1);
              }),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //TODO: pie chart dynamic kari deje dataMap ni value set kairi 6 get_issued_books.dart ma pan nathi thatu
            PieChart(
              dataMap: dataMap,
              colorList: colorList,
              chartValueStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            n_issued_books == 0
                ? Container()
                : Text(
                    'ISSUED BOOKS',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  //TODO: ne aanu pan setting kari deje  
             Expanded(
                    flex: 1,
                    child: GetIssuedBooks()
                  ),
          ],
        ),
      ),
    );
  }
}
