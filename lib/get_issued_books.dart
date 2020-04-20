import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livelibrary/issued_books.dart';
import 'dashboard.dart';
class GetIssuedBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
//          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Issued Books')
                .where("Enrollment No", isEqualTo: "170050107024")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              if (!snapshot.hasData && snapshot.data.documents == null)
                return Text(
                    'No books are available now!!!\n\nPlease try again later.',
                    style: TextStyle(fontSize: 15));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text(
                    'Retrieving Books...',
                    style: TextStyle(fontSize: 20),
                  );
                default:
                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                          n_issued_books = double.parse(snapshot.data.documents.length.toString());
                          dataMap.putIfAbsent('Issued Books', () => n_issued_books);
                      return IssuedBooks(
                        title: document['Title'],
                        returnDate: document['Return Date'],
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
