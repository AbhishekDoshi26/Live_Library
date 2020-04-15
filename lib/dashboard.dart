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
  List<String> titles = ['Complete Reference C++', 'abc'];
  List returndates = ['20/4/2020', '1/2/2020'];

  void initState() {
    super.initState();
    dataMap.putIfAbsent("Issued Books", () => 2);
    dataMap.putIfAbsent("Returned Books", () => 5);
  }

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
            Expanded(
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
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            titles.add('new book');
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
