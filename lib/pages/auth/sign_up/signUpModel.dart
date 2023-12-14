// signUpModel.dart

import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  final unfocusNode = FocusNode();

  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  FocusNode? usernameFocusNode;
  TextEditingController? usernameController;
  String? Function(BuildContext, String?)? usernameControllerValidator;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  bool passwordVisibility = false; // Инициализируем поле passwordVisibility
  String? Function(BuildContext, String?)? passwordControllerValidator;

  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordController;
  bool confirmPasswordVisibility = false; // Инициализируем поле confirmPasswordVisibility
  String? Function(BuildContext, String?)? confirmPasswordControllerValidator;

  // инициализация полей сброса ошибок при невалидном вводе
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? confirmPasswordError;

  bool? checkboxValue;

  void initState(BuildContext context) {
    passwordVisibility = false;
    confirmPasswordVisibility = false;
  }

  void dispose() {
    super.dispose();
    unfocusNode.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    usernameFocusNode?.dispose();
    usernameController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordController?.dispose();
  }

  // проверка на пустую форму
  bool isFormEmpty() {
    if (emailController!.text.isEmpty) {
      if (usernameController!.text.isEmpty) {
        if (passwordController!.text.isEmpty) {
          if (confirmPasswordController!.text.isEmpty) {
            return true;
          }
        }
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
      case 'username':
      // Пример: валидация наличия цифр в пароле
        if (value!.length < 6) {
          usernameError = 'Пароль должен содержать не менее 6 символов';
        }
        else if (!RegExp(r'\d').hasMatch(value)) {
          usernameError = 'Пароль должен содержать хотя бы одну цифру';
        } else {
          usernameError = null;
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
      case 'confirmPassword':
      // Валидация подтверждения пароля
        if (value != passwordController?.text) {
          confirmPasswordError = 'Пароли не совпадают';
        } else {
          confirmPasswordError = null;
        }
        break;
    }

    // Уведомляем слушателей об изменениях
    notifyListeners();

    // Возвращаем ошибку, если она есть
    switch (fieldName) {
      case 'email':
        return emailError;
      case 'username':
        return usernameError;
      case 'password':
        return passwordError;
      case 'confirmPassword':
        return confirmPasswordError;
      default:
        return null;
    }
  }
}
