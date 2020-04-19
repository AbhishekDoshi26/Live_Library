import 'package:flutter/material.dart';

import 'issued_books.dart';

class BookRack extends StatefulWidget {
  @override
  _BookRackState createState() => _BookRackState();
}

class _BookRackState extends State<BookRack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("Book Rack",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
                background: Image.network(
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                //TODO: Ahiya j books fetch kairi book_rack mathi, e display karvani badhi
                return IssuedBooks(
                  title: 'Hello World',
                  returnDate: 'Date',
                );
              }),
        ),
      ),
    );
  }
}
