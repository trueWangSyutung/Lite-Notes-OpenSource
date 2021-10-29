import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangesNamePage extends StatelessWidget {
  ChangesNamePage({Key key}) : super(key: key);
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
                  color: Colors.white,
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
                    child: Text("返回")),
                TextButton(
                    onPressed: () {
                      _saveNameValue(NameController.text);
                      Navigator.pop(context);
                    },
                    child: Text("确定"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
