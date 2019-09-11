import 'package:flutter/material.dart';
import 'package:raisedbutton_sample/BatteryLevelPlugin.dart';
import 'package:raisedbutton_sample/Navigation.dart';
import 'package:raisedbutton_sample/SignaturePainter.dart';
import 'package:raisedbutton_sample/AsyncLoadingList.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
//      home: SignatureApp(),
//      home: NavigationDemoApp(),
//      home: AsyncLoadingListApp(),
      home: PluginApp(),
    );
  }
}