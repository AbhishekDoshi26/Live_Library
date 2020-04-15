import 'package:flutter/material.dart';

class IssuedBooks extends StatelessWidget {
  final textStyle = TextStyle(color: Colors.white, fontSize: 20.0);
  final title;
  final returnDate;

  IssuedBooks({this.title, this.returnDate});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 70.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Title: ' + title,
                  style: textStyle,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Return Date: ' + returnDate,
                  style: textStyle,
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            Image.asset('assets/' + title + '.jpg'),
          ],
        ),
      ),
    );
  }
}
