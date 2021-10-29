import 'package:shared_preferences/shared_preferences.dart';

class SharePUtils {
  static Future _saveNameValue(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("name", value);
  }

  static Future _saveisFirstValue(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isfirst", value);
  }

  static Future<String> _getName() async {
    // 获取文档目录的路径
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("name");
  }
}
