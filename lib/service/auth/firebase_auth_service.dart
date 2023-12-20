import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  // сохранение нового пользователя в базу пользователей
  Future<User?> signUpEmailPassword(BuildContext context, String email, String password) async {

    try {

      // аккаунта не существует, создаем новый аккаунт
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // вывод сообщения об успешном создании нового аккаунта
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'АККАУНТ УСПЕШНО СОЗДАН!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // по умолчанию каждый новый пользователь имеет права user'a
      credential.user?.updateDisplayName('user');

      return credential.user;

    } catch (exc) {

      // обработка ошибок создания аккаунта
      print('sign_up error: $exc');

      // вывод сообщения о неудачной попытке создания нового аккаунта
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'АККАУНТ С ТАКИМ ПОЧТОВЫМ АДРЕСОМ УЖЕ СУЩЕСТВУЕТ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    return null;
  }

  // вход в приложение
  Future<User?> signInEmailPassword(BuildContext context, String email, String password) async {

    try {

      // попытка входа в аккаунт
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch (exc) {

      // обработка ошибок входа в аккаунт
      print('sign_in error: $exc');

      // вывод сообщения о неудачной попытке создания нового аккаунта
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'АККАУНТ С ТАКИМ ПОЧТОВЫМ АДРЕСОМ НЕ СУЩЕСТВУЕТ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    return null;
  }

  // восстановление пароля
  Future<User?> resetPassword(BuildContext context, String email) async {

    try {

      // для защиты от подбора аккаунта проверку на существование пользователя не делаем
      await _auth.sendPasswordResetEmail(email: email);

      // вывод сообщения об успешном создании нового аккаунта
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ПРОВЕРЬТЕ ВАШУ ПОЧТУ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );

      User? user = _auth.currentUser;
      return user;

    } on FirebaseAuthException catch (exc) {

      // обработка ошибок создания аккаунта
      print('pass_reset error: $exc');

      // вывод сообщения о неудачной попытке создания нового аккаунта
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ПРОИЗОШЛА НЕИЗВЕСТНАЯ ОШИБКА',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat', // Укажите название вашего шрифта
              ),
            ),
            backgroundColor: Colors.red,
          ),
      );
    }

    return null;
  }
}