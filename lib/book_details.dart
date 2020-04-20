import 'package:flutter/material.dart';

class BookDetails extends StatelessWidget {
  BookDetails(
      {@required  this.title, this.quantity, this.subject, this.rack});

  // final doc;
  final title;
  final quantity;
  final subject;
  final rack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: Text(title),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Padding(padding: const EdgeInsets.only(top: 20)),
                      // Text("Title: " + title,
                      //     softWrap: true, textAlign: TextAlign.justify),
                      // Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Subject: " + subject, style: TextStyle(fontSize: 18.0),
                          softWrap: true, textAlign: TextAlign.justify),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text(
                        "Rack: " + rack, style: TextStyle(fontSize: 18.0),
                        softWrap: true,
                        textAlign: TextAlign.justify,
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Quantity: " + quantity, style: TextStyle(fontSize: 18.0),
                          softWrap: true, textAlign: TextAlign.justify),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
