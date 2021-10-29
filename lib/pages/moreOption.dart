import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:litenotes/pages/add.dart';

class MoreTools extends StatelessWidget {
  final Uint8List images;
  const MoreTools({Key key, @required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Image.memory(images),
            ),
            Center(
              child: ClipRect(
                // 可裁切矩形
                child: BackdropFilter(
                  // 背景过滤器
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade500),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(10),
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddNotePage()));
                                    },
                                    child: Text(
                                      "撰写文章",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(10),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "添加待办",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                              ),
                            ],
                          ),
                          Container(
                            width: 320,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.all(10),
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "添加待办是画饼的项目，\n 待做",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          )
                        ],
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
  }
}
