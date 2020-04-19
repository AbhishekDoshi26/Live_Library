import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livelibrary/book_rack.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'issued_books.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, double> dataMap = new Map();
  List<Color> colorList = [Colors.red, Colors.blue];
  List<String> titles = [];
  List returndates = [];

  void initState() {
    super.initState();
    dataMap.putIfAbsent("Issued Books", () => 5);
    dataMap.putIfAbsent("Returned Books", () => 5);
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
              tooltip: 'Book Rack',
              icon: FaIcon(FontAwesomeIcons.book),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookRack()));
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
            titles.length == 0
                ? Container()
                : Text(
                    'ISSUED BOOKS',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
            titles.length == 0
                ? Container()
                : Expanded(
                    flex: 1,
                    child: ListView.builder(
                        itemCount: titles.length,
                        itemBuilder: (context, index) {
                          return IssuedBooks(
                            title: titles[index],
                            returnDate: returndates[index],
                          );
                        }),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Book',
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            titles.add('Complete Reference C++');
            returndates.add('5/5/2020');
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}
