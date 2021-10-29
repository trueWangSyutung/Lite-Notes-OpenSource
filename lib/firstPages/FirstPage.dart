import 'package:flutter/material.dart';
import 'package:litenotes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPages extends StatelessWidget {
  const FirstPages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://flutter.cn/asset/flutter-hero-laptop2.png",
              width: 200,
              height: 200,
            ),
            Text("欢迎使用LiteNote"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SecondPage()));
                    },
                    child: Text("下一步"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  String x = """
  本软件尊重并保护所有使用服务用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本软件会按照本隐私权政策的规定
  使用和披露您的个人信息。但本软件将以高度的勤勉、审慎义务对待这些信息。除本隐私权政策另有规定外，在未征得您事先许可
  的情况下，本软件不会将这些信息对外披露或向第三方提供。本软件会不时更新本隐私权政策。您在同意本软件服务使用协议之时
  ，即视为您已经同意本隐私权政策全部内容。本隐私权政策属于本软件服务使用协议不可分割的一部分。
一、信息收集
本软件不会对您的个人信息进行采集，并对你进行个性化推荐。请您放心使用。
二、保留问题
隐私协议解释权归本软件所有，将来若有隐私项收集，本隐私协议会及时更新。
  """;
  SecondPage({Key key}) : super(key: key);
  Future _saveisFirstValue(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("first", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("隐私协议"),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(x, softWrap: true, style: TextStyle()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      _saveisFirstValue("true");
                      Navigator.pop(context);
                    },
                    child: Text("拒绝")),
                TextButton(
                    onPressed: () {
                      _saveisFirstValue("false");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ThirdPage()));
                    },
                    child: Text("同意"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  ThirdPage({Key key}) : super(key: key);
  TextEditingController NameController = TextEditingController();
  Future _saveNameValue(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("name", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("我的信息"),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: TextField(
                controller: NameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "姓名",
                    labelStyle: TextStyle()),
                maxLines: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("上一步")),
                TextButton(
                    onPressed: () {
                      _saveNameValue(NameController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MyHomePage()));
                    },
                    child: Text("下一步"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
