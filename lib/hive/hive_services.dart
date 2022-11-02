

import 'package:hive/hive.dart';

class HiveServices {
  static String boxName = "handley_box";
  static String onBoardingKey = "onBoardingKey";
  static var handleyHiveBox;

  static  openBox(String boxName) async {
    handleyHiveBox = await Hive.openBox(boxName);

  }
  static  insertString(String key,String value) async {
    handleyHiveBox.put(key, value);
  }

  static Future<String?> getString(String key) async {

   return  handleyHiveBox.get(key);
  }

  static  deleteString(String key) async {
    handleyHiveBox.delete(key);
  }
}




