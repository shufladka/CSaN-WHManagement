import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFormValidator {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final bool needPassword;
  final bool needConfirmPassword;

  // размер шрифта
  static const double customFontSize = 12;

  CustomFormValidator({
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
    required this.needPassword,
    required this.needConfirmPassword
  });

  // проверка на пустую форму при различных параметрах
  bool isFormEmpty() {
    if (emailController!.text.isEmpty) {
      if ((needPassword && passwordController!.text.isEmpty) || (!needPassword && !needConfirmPassword)) {
        if (needConfirmPassword && confirmPasswordController!.text.isEmpty) {
          return true;
        } else if (!needConfirmPassword) {
          // Если подтверждение пароля не требуется, форма считается пустой
          return true;
        }
      }
    }

    return false;
  }

  // метод для валидации формы
  bool validateForm(BuildContext context) {

    // Проверяем, пуста ли форма
    if (isFormEmpty()) {

      // если форма пуста, выведем ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ЗАПОЛНИТЕ ВСЕ ПОЛЯ ФОРМЫ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: customFontSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

      // прекращаем выполнение метода
      return false;
    }

    // проверка условий валидности формы
    if (emailValidate(context)) {
      if (passwordValidate(context)) {
        if (compareValidator(context)) {

          //  код для обработки создания аккаунта (будет стерт)
          print('Button pressed ...');

          return true;
        }
      }
    }

    return false;
  }

  // верификация поля "почтовый адрес"
  bool emailValidate(BuildContext context) {

    // для упрощения валидации по почтовому адресу
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (emailController!.text.length < 7 || emailController!.text.length > 320) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ПОЧТОВЫЙ АДРЕС ДОЛЖЕН ИМЕТЬ ОТ 7 ДО 320 СИМВОЛОВ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: customFontSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

      // прекращаем выполнение метода
      return false;
    }

    if (!emailRegExp.hasMatch(emailController!.text.trim())) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'НЕВАЛИДНЫЙ ПОЧТОВЫЙ АДРЕС',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: customFontSize,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

      // прекращаем выполнение метода
      return false;
    }

    return true;
  }

  // верификация поля "пароль"
  bool passwordValidate(BuildContext context) {
    if (needPassword) {

      RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9]{8,30}$');

      if (passwordController!.text.length < 8 || passwordController!.text.length > 30) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ПАРОЛЬ ДОЛЖЕН ИМЕТЬ ОТ 8 ДО 30 СИМВОЛОВ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: customFontSize,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat', // Укажите название вашего шрифта
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );

        // прекращаем выполнение метода
        return false;
      }

      if (!passwordRegExp.hasMatch(passwordController!.text.trim())) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ПАРОЛЬ ДОЛЖЕН СОДЕРЖАТЬ ЛАТИНСКИЕ БУКВЫ И ЦИФРЫ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: customFontSize,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat', // Укажите название вашего шрифта
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );

        // прекращаем выполнение метода
        return false;
      }
    }

    return true;
  }

  // сравнение полей "пароль" и "подтвердите пароль"
  bool compareValidator(BuildContext context) {
    if (needPassword && needConfirmPassword) {
      if (passwordController?.text != confirmPasswordController?.text) {
        // Если не совпадают, выведем ошибку (можно использовать SnackBar)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ПАРОЛИ НЕ СОВПАДАЮТ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: customFontSize,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat', // Укажите название вашего шрифта
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        // Прекращаем выполнение метода
        return false;
      }
    }

    return true;
  }
}
