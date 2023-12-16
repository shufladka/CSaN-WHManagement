import 'package:shared_preferences/shared_preferences.dart';

// класс для очистки сохраненных данных пользователя
class ClearUserData {
  static final ClearUserData _instance = ClearUserData._internal();

  factory ClearUserData() {
    return _instance;
  }

  ClearUserData._internal();

  // метод для очистки сохраненных данных пользователя
  Future<void> clearSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('rememberMe');
    prefs.remove('savedEmail');
    prefs.remove('savedPassword');
  }
}