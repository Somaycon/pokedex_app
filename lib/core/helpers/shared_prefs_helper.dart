import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static SharedPreferences? _instance;
  static Future<SharedPreferences> get instance async {
    if (_instance != null) return _instance!;
    _instance = await SharedPreferences.getInstance();
    return _instance!;
  }
}
