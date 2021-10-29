import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litenotes/datebase/sqlite.dart';
import 'package:litenotes/empty/note.dart';
import 'package:litenotes/empty/number.dart';
import 'package:litenotes/firstPages/FirstPage.dart';
import 'package:litenotes/firstPages/luncherPage.dart';
import 'package:litenotes/pages/ChangesPage.dart';
import 'package:litenotes/pages/MinePage.dart';
import 'package:litenotes/pages/NotesList.dart';
import 'package:litenotes/pages/add.dart';
import 'package:litenotes/pages/moreOption.dart';
import 'package:litenotes/utils/ShareUtils.dart';
import 'package:litenotes/widgets/Listitem.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(MyAPP());
}

class MyAPP extends StatefulWidget {
  const MyAPP({Key key}) : super(key: key);

  @override
  _MyAPPState createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> {
  String a = "true";
  Future<void> _getisFirst() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      a = sharedPreferences.getString("first");
    });
  }

  @override
  initState() {
    super.initState();
    _getisFirst();
  }

  @override
  Widget build(BuildContext context) {
    if (a == "true") {
      return MaterialApp(
        title: 'LiteNote',
        shortcuts: WidgetsApp.defaultShortcuts,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        home: FirstPages(),
      );
    } else if (a == "false") {
      return MaterialApp(
        title: 'LiteNote',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        home: LaunchPage(),
      );
    } else {
      return MaterialApp(
        title: 'LiteNote',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        home: FirstPages(),
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var list = ['笔记', "我的"];
  int currentIndex = 0;
  GlobalKey key = new GlobalKey();
  Future getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      GlobalNumber.username = sharedPreferences.get("name");
    });
  }

  final items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.view_list),
      title: Text("笔记"),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: Text("我的"),
    ),
  ];
  @override
  void initState() {
    super.initState();
    getString();
  }

  final bodyLists = [NoteListPage(), MinePages()];
  Future<Uint8List> _getImageData() async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes; //这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.lightBlue,
        type: BottomNavigationBarType.fixed,
      ),
      body: RepaintBoundary(
        key: key,
        child: bodyLists[currentIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getImageData().then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MoreTools(images: value)));
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onTap(int value) {
    setState(() {
      currentIndex = value;
    });
  }
}
