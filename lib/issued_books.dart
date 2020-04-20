import 'package:flutter/material.dart';

class IssuedBooks extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 20.0);
  final title;
  final returnDate;

  IssuedBooks({this.title, this.returnDate});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: 250,
          padding: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Title: ' + title + '\nReturn Date: ' + returnDate,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
