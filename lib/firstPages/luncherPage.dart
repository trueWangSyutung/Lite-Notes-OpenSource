import 'dart:async';

import 'package:flutter/material.dart';
import 'package:litenotes/main.dart';

class LaunchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LaunchPageWidget();
  }
}

class LaunchPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaunchState();
}

class LaunchState extends State<LaunchPageWidget> {
  final String launchImage =
      "https://flutter.cn/asset/flutter-hero-laptop2.png";
  int _countdown = 2;
  Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startRecordTime();
    print('初始化启动页面');
  }

  @override
  void dispose() {
    super.dispose();
    print('启动页面结束');
    if (_countdownTimer != null && _countdownTimer.isActive) {
      _countdownTimer.cancel();
      _countdownTimer = null;
    }
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown <= 1) {
//          Navigator.of(context).pushNamed("/demo1");
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MyHomePage();
          }));
          _countdownTimer.cancel();
          _countdownTimer = null;
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://flutter.cn/asset/flutter-hero-laptop2.png",
              width: 200,
              height: 200,
            ),
            Text(
              "Lite Note",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
