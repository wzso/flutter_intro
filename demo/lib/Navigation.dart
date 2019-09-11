import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _DemoPage(title: 'Home'),
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => _DemoPage(title: "Page A"),
        '/b': (BuildContext context) => _DemoPage(title: "Page B"),
        '/c': (BuildContext context) => _DemoPage(title: "Page C"),
        '/d': (BuildContext context) => _DemoPage(title: "Page D"),
      },
    );
  }
}

class _DemoPage extends StatelessWidget {
  _DemoPage({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).pushNamed('/a');
        },
      ),
    );
  }
}