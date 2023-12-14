import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/auth/sign_in/signInWidget.dart';
import 'pages/auth/sign_up/signUpWidget.dart';
import 'pages/home/lobby/lobbyWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'title',
      theme: ThemeData(
        // Здесь вы можете настроить тему приложения, если необходимо
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Задайте вашу начальную страницу, если нужно
      routes: {
        '/': (context) => const SignInWidget(), // маршруты
        'sign_in': (context) => const SignInWidget(), // маршруты
        'sign_up': (context) => const SignUpWidget(), // маршруты
        'lobby':  (context) => const LobbyWidget(), // маршруты
      },
    );
  }
}