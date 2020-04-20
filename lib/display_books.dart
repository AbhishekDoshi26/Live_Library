import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livelibrary/book_details.dart';
//TODO: Ahiya databse mathi books fetch karvani jema collection nu name Books che!! Display only those books which are for the sem of the students


class CustomCard extends StatelessWidget {
  CustomCard(
      {@required 
      // this.doc,
      this.title,
      this.quantity,
      this.subject,
      this.rack});

  // final doc;
  final title;
  final quantity;
  final subject;
  final rack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetails(
                      // doc: doc,
                      title: title,
                      quantity: quantity,
                      subject: subject,
                      rack: rack,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 65,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: new Text("Recomended Books"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Books')
                .where("Sem", isEqualTo: "6")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              if (!snapshot.hasData && snapshot.data.documents == null)
                return new Text(
                    'No books are available now!!!\n\nPlease try again later.',
                    style: TextStyle(fontSize: 15));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text(
                    'Retrieving Books...',
                    style: TextStyle(fontSize: 20),
                  );
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return CustomCard(
                        // doc: document.documentID,
                        quantity: document['Quantity'],
                        subject: document['Subject'],
                        title: document['Title'],
                        rack: document['Rack'],
                      );
                    }).toList(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
