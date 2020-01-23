import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
      home: new HomePage(),
      routes: <String, WidgetBuilder> {
        "/SecondPage": (BuildContext context) => new SecondPage()
      }
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new Drawer(),
        appBar: new AppBar(
            title: new Text("Home"),
            actions: <Widget>[

            ],
            backgroundColor: Colors.deepOrange
        ),
        body: Center(
           child: Text("COWBOY BEAN BOWL")
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondPage()),
            );
          },
          child: Icon(Icons.create),
          backgroundColor: Colors.amber,
        ),

    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(),
      appBar: new AppBar(
          title: new Text("Page #2"),
          actions: <Widget>[

          ],
          backgroundColor: Colors.deepOrange
      ),
      body: Center(
          child: Text("SEE YOU LATER SPACE COWBOY")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.create),
        backgroundColor: Colors.amber,
      ),

    );
  }
}