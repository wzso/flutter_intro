import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PluginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugin Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(title: 'Interact with native'),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  _MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  static const _channel = const MethodChannel('samples.flutter.dev/battery');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  @override
  void initState() {
    super.initState();
    // 设置原生调用的回调
    _channel.setMethodCallHandler(_nativeCallHandler);
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      // 调用原生方法
      // 不通平台的数据类型对应关系请参考： https://flutter.dev/docs/development/platform-integration/platform-channels#platform-channel-data-types-support-and-codecs
      final int result = await _channel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  /// 原生调用的 handler
  Future<dynamic> _nativeCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'foo':
        return 1990;
      default:
        throw Exception('Unhandled method: ' + methodCall.method);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:  Text(
          _batteryLevel,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getBatteryLevel,
        tooltip: 'Get',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
