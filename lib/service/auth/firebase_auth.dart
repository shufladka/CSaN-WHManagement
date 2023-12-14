import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpEmailPassword(BuildContext context, String email, String password) async {

    try {

      // аккаунта не существует, создаем новый аккаунт
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // вывод сообщения об успешном создании нового аккаунта
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Аккаунт успешно создан!',
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
            'аккаунт с таким почтовым адресом уже существует.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat', // Укажите название вашего шрифта
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );


      return null;
    }
  }

  Future<User?> signInEmailPassword(String email, String password) async {

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch (exc) {
      print('sign_in error');
    }

    return null;
  }
}