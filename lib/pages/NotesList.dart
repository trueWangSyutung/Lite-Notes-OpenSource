import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:litenotes/datebase/sqlite.dart';
import 'package:litenotes/empty/note.dart';
import 'package:litenotes/empty/number.dart';
import 'package:litenotes/pages/ChangesPage.dart';
import 'package:litenotes/pages/MinePage.dart';
import 'package:litenotes/pages/add.dart';
import 'package:litenotes/widgets/Listitem.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key key}) : super(key: key);

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  AsyncMemoizer asyncMemoizer = AsyncMemoizer();
  List<Note> lists = [];
  // 删除笔记
  void _delNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      lists.removeWhere((element) => element.id == id);
    });
  }

  // 初始化
  @override
  initState() {
    re();

    super.initState();
  }

  // 刷新数据
  Future<void> re() async {
    DatabaseHelper.instance.queryAllRows().then((value) {
      lists = [];
      value.forEach((element) {
        var p = Note(
            element['id'], element['title'], element["text"], element['date']);

        setState(() {
          lists.add(p);
        });
      });
    });
  }

  @override
  void didUpdateWidget(NoteListPage oldwidget) {
    super.didUpdateWidget(oldwidget);
  }

  @override
  Widget build(BuildContext context) {
    print(lists[0].toMap());

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("笔记"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MinePages()));
                },
                child: Text(
                  "我的",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
      body: EasyRefresh(
          onRefresh: re,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return ListItem(
                  note: lists[index],
                  click: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChangesPages(id: lists[index].id)));
                  },
                  longclick: () {
                    _delNote(lists[index].id);
                    Fluttertoast.showToast(
                        msg: "删除成功",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                );
              })),

      // ignore: missing_return
    );
  }
}
