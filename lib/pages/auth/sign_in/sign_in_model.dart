// sign_up_model.dart

import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  bool passwordVisibility = false; // Инициализируем поле passwordVisibility
  String? Function(BuildContext, String?)? passwordControllerValidator;

  // инициализация полей сброса ошибок при невалидном вводе
  String? emailError;
  String? passwordError;

  bool? checkboxValue;

  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  void dispose() {
    super.dispose();
    unfocusNode.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();
  }

  // проверка на пустую форму
  bool isFormEmpty() {
    if (emailController!.text.isEmpty) {
      if (passwordController!.text.isEmpty) {
        return true;
      }
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
        break;
      case 'password':
      // Валидация пароля, например, на длину
        if (value!.length < 6) {
          passwordError = 'Пароль должен содержать не менее 6 символов';
        } else {
          passwordError = null;
        }
        break;
    }

    // Уведомляем слушателей об изменениях
    notifyListeners();

    // Возвращаем ошибку, если она есть
    switch (fieldName) {
      case 'email':
        return emailError;
      case 'password':
        return passwordError;
      default:
        return null;
    }
  }
}
