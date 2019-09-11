import 'package:flutter/material.dart';

class FadingAnimationDemoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fade Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FadeTest(title: 'Fade Test'),
    );
  }
}

/// Widget
class FadeTest extends StatefulWidget {
  FadeTest({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FadeTest createState() => _FadeTest();
}

/// State
class _FadeTest extends State<FadeTest> with TickerProviderStateMixin {
  AnimationController _controller;
  CurvedAnimation _curve;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title)
      ),
      body: Center(
        child: Container(
          child: FadeTransition(
            opacity: _curve,
            child: FlutterLogo(
                size: 100.0
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        child: Icon(Icons.brush),
        onPressed: () {
          if (_curve.isCompleted) {
            // animate back
            _controller.animateBack(0);
          } else {
            _controller.forward();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('initState');
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
    _controller.dispose();
  }
}


