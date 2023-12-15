import 'package:flutter/material.dart';

class PassResetModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  // инициализация полей сброса ошибок при невалидном вводе
  String? emailError;

  @override
  void dispose() {
    super.dispose();
    unfocusNode.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();
  }

  // проверка на пустую форму
  bool isFormEmpty() {
    if (emailController!.text.isEmpty) {
      return true;
    }

    return false;
  }

  // метод для валидации значений
  String? validate(String? value, String fieldName) {
    switch (fieldName) {
      case 'email':
      // Пример: валидация по длине текста
        if (value!.length < 10) {
          emailError = 'Почтовый адрес должен содержать не менее 10 символов';
        } else {
          emailError = null;
        }
    }

    // Уведомляем слушателей об изменениях
    notifyListeners();

    // Возвращаем ошибку, если она есть
    switch (fieldName) {
      case 'email':
        return emailError;
    }
    return null;
  }
}