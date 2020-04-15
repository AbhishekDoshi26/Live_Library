import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'issued_books.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, double> dataMap = new Map();
  List<Color> colorList = [Colors.red, Colors.cyan];

  void initState() {
    super.initState();
    dataMap.putIfAbsent("Issued Books", () => 2);
    dataMap.putIfAbsent("Returned Books", () => 5);
  }

  List<TableRow> tableRow = [
    TableRow(children: <Widget>[
      Text('Hello'),
      Text('World'),
    ])
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text('Dashboard'),
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
            Text(
              'ISSUED BOOKS',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15.0,
            ),
            IssuedBooks(
              title: 'Complete Reference C++',
              returnDate: '22/04/2020',
            ),
            SizedBox(
              height: 15.0,
            ),
            IssuedBooks(
              title: 'Complete Reference C++',
              returnDate: '22/04/2020',
            ),
            SizedBox(
              height: 15.0,
            ),
            IssuedBooks(
              title: 'Complete Reference C++',
              returnDate: '22/04/2020',
            ),
          ],
        ),
      ),
    );
  }
}
