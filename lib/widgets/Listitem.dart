import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litenotes/datebase/sqlite.dart';
import 'package:litenotes/empty/note.dart';
import 'package:litenotes/pages/ChangesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
/// *
/// 笔记小卡片
class ListItem extends StatefulWidget {
  Note note;
  Function click;
  Function longclick;

  ListItem({Key key, this.note, this.click, this.longclick}) : super(key: key);

  @override
  _ListItemState createState() =>
      _ListItemState(note: note, click: click, longclick: longclick);
}

class _ListItemState extends State<ListItem> {
  Note note;
  Function() longclick;
  Function() click;

  bool isclick = false;
  bool isLongClick = false;
  GlobalKey key = new GlobalKey();
  Uint8List pngBytes2;
  Future<Uint8List> _getImageData() async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      setState(() {
        this.pngBytes2 = pngBytes;
      });
      return pngBytes; //这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

  String username;
  Future getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.get("name");
    });
  }

  @override
  void initState() {
    super.initState();
    getString();
  }

  void _delNote(int id) async {
    await DatabaseHelper.instance.delete(id);
  }

  _ListItemState({this.note, this.click, this.longclick});
  Widget getClick(int id) {
    if (!isclick) {
      return Container();
    } else {
      return Container(
        child: TextButton(onPressed: longclick, child: Text("删除该笔记")),
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      );
    }
  }

  @override
  void didUpdateWidget(ListItem oldwidget) {
    super.didUpdateWidget(oldwidget);
  }

  Widget getLongClick() {
    if (isLongClick) {
      return Container(
        height: 200,
        child: Center(
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Image.memory(pngBytes2),
              ),
              Center(
                child: ClipRect(
                  // 可裁切矩形
                  child: BackdropFilter(
                    // 背景过滤器
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade500),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isLongClick) {
                                          isLongClick = false;
                                        } else {
                                          isLongClick = true;
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    )),
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: TextButton(
                                    onPressed: longclick,
                                    child: Center(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    )),
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: click,
        onLongPress: () {
          setState(() {
            _getImageData();
            if (isLongClick) {
              isLongClick = false;
            } else {
              isLongClick = true;
            }
          });
        },
        child: RepaintBoundary(
          key: key,
          child: Card(
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          this.widget.note.title,
                          style: TextStyle(fontSize: 25),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        this.widget.note.text,
                        textAlign: TextAlign.left,
                        style: TextStyle(),
                        maxLines: 3,
                        softWrap: true,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "作者：" + username + "\n" + this.widget.note.date,
                        style: TextStyle(fontSize: 12),
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.all(15),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getLongClick();
  }
}
