import 'package:flutter/material.dart';

class LobbyModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  FocusNode? t1FocusNode;
  TextEditingController? t1Controller;
  String? Function(BuildContext, String?)? t1ControllerValidator;

  FocusNode? t2FocusNode;
  TextEditingController? t2Controller;
  bool t2Visibility = false; // Инициализируем поле t2Visibility
  String? Function(BuildContext, String?)? t2ControllerValidator;

  // инициализация полей сброса ошибок при невалидном вводе
  String? t1Error;
  String? t2Error;

  bool? checkboxValue;

  void initState(BuildContext context) {
    t2Visibility = false;
  }

  @override
  void dispose() {
    super.dispose();
    unfocusNode.dispose();

    t1FocusNode?.dispose();
    t1Controller?.dispose();

    t2FocusNode?.dispose();
    t2Controller?.dispose();
  }

  // проверка на пустую форму
  bool isFormEmpty() {
    if (t1Controller!.text.isEmpty) {
      if (t2Controller!.text.isEmpty) {
        return true;
      }
    }

    return false;
  }

  // метод для валидации значений
  String? validate(String? value, String fieldName) {
    switch (fieldName) {
      case 't1':
      // Пример: валидация по длине текста
        if (value!.length < 10) {
          t1Error = 'Почтовый адрес должен содержать не менее 10 символов';
        } else {
          t1Error = null;
        }
        break;
      case 't2':
      // Валидация пароля, например, на длину
        if (value!.length < 6) {
          t2Error = 'Пароль должен содержать не менее 6 символов';
        } else {
          t2Error = null;
        }
        break;
    }

    // Уведомляем слушателей об изменениях
    notifyListeners();

    // Возвращаем ошибку, если она есть
    switch (fieldName) {
      case 't1':
        return t1Error;
      case 't2':
        return t2Error;
      default:
        return null;
    }
  }
}
