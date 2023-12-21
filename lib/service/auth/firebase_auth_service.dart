import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final FirebaseAuthService _authService = FirebaseAuthService();

  // сохранение нового пользователя в базу пользователей
  Future<User?> signUpEmailPassword(BuildContext context, String email, String password) async {

    try {

      // аккаунта не существует, создаем новый аккаунт
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Получаем роль из таблицы default_role
      String? defaultRole = await getDefaultRole();

      if (defaultRole == null) {
        print('Не удалось получить роль из таблицы default_role.');
        return null;
      }

      // сохраняем адрес электронной почты пользователя в Firestore в коллекции 'users'
      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'role': defaultRole,
      });

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

  // метод для проверки соответствия прав текущего пользователя и необходимых прав для выполнения операции
  Future<bool> isItRightRole(String? rightRole) async {

    String? role = await _authService.getUserRole(_auth.currentUser!.uid);
    print(role);

    return (role == rightRole);
  }


  // получение прав доступа пользователя при сравнении данных в Firebase Firestore и Firebase Auth
  Future<String?> getUserRole(String uid) async {
    try {

      // проверяем, есть ли текущий пользователь
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('Текущий пользователь не найден.');
        return null;
      }

      // получаем документ пользователя из базы данных
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {

        // роль пользователя хранится в поле 'role'
        String? userRole = userDoc['role'];

        if (userRole != null) {

          // устанавливаем роль текущему пользователю (опционально)
          await currentUser.updateDisplayName(userRole);

          return userRole;
        } else {
          print('Поле "role" не найдено в документе пользователя.');
          return null;
        }
      } else {
        print('Документ пользователя не найден.');
        return null;
      }
    } catch (e) {
      print('Ошибка при получении роли пользователя: $e');
      return null;
    }
  }

  // получение роли пользователя по умолчанию из таблицы default_role
  Future<String?> getDefaultRole() async {
    try {
      DocumentSnapshot defaultRoleDoc = await _firestore.collection('default_role').doc('0epnU1hXUOjTKgjmTsQh').get();

      if (defaultRoleDoc.exists) {
        // роль хранится в поле 'role'
        return defaultRoleDoc['role'];
      } else {
        print('Документ с ролями не найден.');
        return null;
      }
    } catch (e) {
      print('Ошибка при получении роли из таблицы default_role: $e');
      return null;
    }
  }

  // Установка роли пользователя в таблице default_role
  Future<void> setDefaultRole(String role) async {
    try {
      await _firestore.collection('default_role').doc('0epnU1hXUOjTKgjmTsQh').update({
        'role': role,
      });
      print('Роль успешно обновлена в таблице default_role.');
    } catch (e) {
      print('Ошибка при обновлении роли в таблице default_role: $e');
    }
  }

  // проверка на принадлежность пользователя к привилегированной группе "Администратор"

  Future<bool> checkingForAdministratorPrivileges(String rightRole) async {
    try {
      // Получение результата проверки
      bool isAdmin = await _authService.isItRightRole(rightRole);

      return isAdmin;
    } catch (e) {
      // Обработка ошибок при проверке привилегий
      print('Checking privileges error: $e');
      return false; // Возвращаем false в случае ошибки
    }
  }
}