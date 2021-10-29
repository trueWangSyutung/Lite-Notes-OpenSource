import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litenotes/datebase/imagessqlite.dart';
import 'package:litenotes/datebase/sqlite.dart';
import 'package:litenotes/empty/image.dart';
import 'package:litenotes/empty/note.dart';
import 'package:litenotes/empty/number.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _textController = new TextEditingController();
  String date;
  int id;
  var timer;
  List<Images> lists;
  String tool = "预览";
  String imagepath;
  String getDate() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year}年${dateTime.month}月${dateTime.day}日${dateTime.hour}时${dateTime.minute}";
  }

  int getId() {
    DateTime dateTime = DateTime.now();
    Random random = new Random();
    return int.parse(
        "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${random.nextInt(300)}");
  }

  Future<String> selectPic() async {
//    FilePickerResult result = await FilePicker.platform.pickFiles(); //单选

    FilePickerResult result = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pnd', 'rw2'],
    ));
    if (result != null) {
      PlatformFile file = result.files.first;
      print('name:' + file.name);

      print(file.path);

      return file.path;
    } else {
      //user cancled the picker
      print('用户停止了选择图片');
      return null;
    }
  }

  void updPic(int id) async {
    String oldpath = await selectPic();
    final File image = File(oldpath);
    final Directory q = await getApplicationDocumentsDirectory();
    final String r = q.path;
    Random random = new Random();
    String aaa = "/${id}-${random.nextInt(200)}.png";
    final File newImage = await image.copy('$r$aaa');
    //ImageDatabaseHelper.instance.insert(Images(id, newImage.path));

    _textController.text = _textController.text + "\n" + " ![图片注释](${aaa})\n";

    Fluttertoast.showToast(
        msg: "添加成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> getImagePath() async {
    Directory q = await getApplicationDocumentsDirectory();
    setState(() {
      imagepath = q.path;
    });
  }

  void _delNote(String path) async {
    await ImageDatabaseHelper.instance.delete(this.id, path);
    lists.removeWhere((element) => element.id == id && element.url == path);
    Fluttertoast.showToast(
        msg: "删除成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      lists.remove(Images(id, path));
    });
  }

  Future autoSave() async {
    String title = _titleController.text;
    String text = _textController.text;
    var r;
    if ((title == "" && text != "") || (title != null && text == null)) {
      title = "无标题";
      r = await DatabaseHelper.instance.update(Note(id, title, text, date));
      Fluttertoast.showToast(
          msg: "自动保存成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if ((title == "" && text == "") || (title == null && text == null)) {
    } else if ((title != "" && text != "") || (title != null && text != null)) {
      r = await DatabaseHelper.instance.update(Note(id, title, text, date));

      Fluttertoast.showToast(
          msg: "自动保存成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {}
  }

  void _addNote() async {
    String title = _titleController.text;
    String text = _textController.text;
    var r;
    if ((title == "" && text != "") || (title != null && text == null)) {
      title = "无标题";
      r = await DatabaseHelper.instance.update(Note(id, title, text, date));
      Fluttertoast.showToast(
          msg: "保存成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if ((title == "" && text == "") || (title == null && text == null)) {
    } else if ((title != "" && text != "") || (title != null && text != null)) {
      r = await DatabaseHelper.instance.update(Note(id, title, text, date));
      Fluttertoast.showToast(
          msg: "保存成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    _addNote();
    timer?.cancel();
  }

  @override
  initState() {
    setState(() {
      date = getDate();
      id = getId();
    });
    super.initState();
    DatabaseHelper.instance.insert(Note(id, "", "", date));

    getImagePath();

    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => autoSave());
  }

  Widget getText() {
    if (tool == "编辑") {
      return Markdown(
          imageDirectory: imagepath,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          data: _textController.text);
    } else if (tool == "预览") {
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        child: TextField(
          controller: _textController,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "内容",
              labelStyle: TextStyle()),
          maxLength: 5000,
          maxLines: null,
        ),
      );
    }
  }

  GlobalKey key = new GlobalKey();

  Uint8List pngBytes2;
  Future<Uint8List> _getImageData() async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }
      Random random = new Random();
      if (byteData != null) {
        String path = dirloc + "${id}${random.nextInt(100)}.jpg";

        File(path).create();
        File(path).writeAsBytes(pngBytes);

        Fluttertoast.showToast(
            msg: "保存到本地成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return pngBytes; //这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  Widget getShare() {
    if (tool == "编辑") {
      return TextButton(
          onPressed: () {
            _getImageData();
          },
          child: Text(
            "分享",
            style: TextStyle(color: Colors.white),
          ));
    } else {
      return Container();
    }
  }

  Widget getShuiYin() {
    if (tool == "编辑") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [Text("来自：LiteNote")],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    if (tool == "编辑") {
                      setState(() {
                        tool = "预览";
                      });
                      timer = Timer.periodic(
                          Duration(seconds: 15), (Timer t) => autoSave());
                    } else if (tool == "预览") {
                      setState(() {
                        tool = "编辑";
                      });
                      timer?.cancel();
                    }
                  },
                  child: Text(
                    tool,
                    style: TextStyle(color: Colors.white),
                  )),
              getShare(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 20),
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    TextSelection a = _textController.selection;
                    _textController.text = _textController.text.replaceRange(
                        a.start,
                        a.end,
                        "# ${_textController.text.substring(a.start, a.end)}\n");
                  },
                  child: Icon(Icons.title)),
              TextButton(
                  onPressed: () {
                    TextSelection a = _textController.selection;
                    _textController.text = _textController.text.replaceRange(
                        a.start,
                        a.end,
                        "**${_textController.text.substring(a.start, a.end)}**");
                  },
                  child: Icon(Icons.format_bold)),
              TextButton(
                  onPressed: () {
                    TextSelection a = _textController.selection;
                    _textController.text = _textController.text.replaceRange(
                        a.start,
                        a.end,
                        "*${_textController.text.substring(a.start, a.end)}*");
                  },
                  child: Icon(Icons.format_italic)),
              TextButton(
                  onPressed: () {
                    TextSelection a = _textController.selection;
                    _textController.text = _textController.text.replaceRange(
                        a.start,
                        a.end,
                        ">${_textController.text.substring(a.start, a.end)}\n");
                  },
                  child: Icon(Icons.format_quote)),
              TextButton(
                  onPressed: () {
                    TextSelection a = _textController.selection;
                    _textController.text = _textController.text.replaceRange(
                        a.start,
                        a.end,
                        "[${_textController.text.substring(a.start, a.end)}](在这里替换超链接地址)");
                  },
                  child: Icon(Icons.format_underline)),
              TextButton(
                  onPressed: () {
                    Future.wait([
                      // 2秒后返回结果
                      Future.delayed(new Duration(milliseconds: 200), () {
                        return updPic(id);
                      }),
                    ]).then((results) {
                      print("OK");
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Icon(Icons.image))
            ],
          ),
        ),
        body: RepaintBoundary(
          key: key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                  padding: EdgeInsets.all(5),
                  height: 100,
                  child: TextField(
                    controller: _titleController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "请输入标题栏",
                        labelStyle: TextStyle(fontSize: 30)),
                    maxLines: 2,
                    maxLength: 80,
                  ),
                ),
                getText(),
                getShuiYin()
              ],
            ),
          ),
        ));
  }
}
