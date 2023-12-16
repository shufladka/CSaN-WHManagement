import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/auth/sign_in_page.dart';
import 'pages/auth/sign_up_page.dart';
import 'pages/home/lobby_page.dart';
import 'pages/auth/pass_reset_page.dart';

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

        // отключает анимации, но при этом появляются фризы и задержки
        // pageTransitionsTheme: const PageTransitionsTheme(builders: {
        //   TargetPlatform.android: NoTransitionsPageTransitionsBuilder(),
        //   TargetPlatform.iOS: NoTransitionsPageTransitionsBuilder(),
        //   TargetPlatform.linux: NoTransitionsPageTransitionsBuilder(),
        //   TargetPlatform.macOS: NoTransitionsPageTransitionsBuilder(),
        //   TargetPlatform.windows: NoTransitionsPageTransitionsBuilder(),
        // }),
      ),
      initialRoute: '/', // Задайте вашу начальную страницу, если нужно
      routes: {
        '/': (context) => const SignInPage(), // маршруты
        'sign_in': (context) => const SignInPage(), // вход в приложение
        'sign_up': (context) => const SignUpPage(), // регистрация
        'pass_reset': (context) => const PassResetPage(), // сброс пароля
        'lobby':  (context) => const LobbyPage(), // лобби приложения
      },
    );
  }
}

// класс, который отключает анимации при переходе между страницами
class NoTransitionsPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child; // Отключаем анимации
  }
}