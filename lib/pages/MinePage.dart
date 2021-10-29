import 'package:flutter/material.dart';
import 'package:litenotes/empty/number.dart';
import 'package:litenotes/firstPages/ChangesNamePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinePages extends StatefulWidget {
  const MinePages({Key key}) : super(key: key);

  @override
  _MinePagesState createState() => _MinePagesState();
}

class _MinePagesState extends State<MinePages> {
  Future getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      GlobalNumber.username = sharedPreferences.get("name");
    });
  }

  Future saveString(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  @override
  void initState() {
    super.initState();
    getString();
  }

  Widget getUserInformation() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "用户名：${GlobalNumber.username}",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                onPressed: () {
                                  showLicensePage(
                                      context: context,
                                      applicationIcon: Image.network(
                                        "https://flutter.cn/asset/flutter-hero-laptop2.png",
                                        width: 200,
                                        height: 200,
                                      ),
                                      applicationName: "Lite Note Book",
                                      applicationVersion: "v1.0.0",
                                      applicationLegalese: "Lite Note Book");
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.menu_open_sharp,
                                      color: Colors.greenAccent,
                                    ),
                                    Text("开源许可")
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ChangesNamePage()));
                                  getString();
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.change_history,
                                      color: Colors.greenAccent,
                                    ),
                                    Text("修改名字")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("我的"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              getUserInformation(),
            ],
          ),
        ));
  }
}
