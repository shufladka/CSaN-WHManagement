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

/*
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
      initialRoute: 'lobby', // начальная страница
      routes: {
        '/': (context) => const SignInPage(), // начальная страница
        'sign_in': (context) => const SignInPage(), // вход в приложение
        'sign_up': (context) => const SignUpPage(), // регистрация
        'pass_reset': (context) => const PassResetPage(), // сброс пароля
        'lobby':  (context) => const LobbyPage(), // лобби приложения
      },
    );
  }
}

 */

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (settings.name) {
              case '/':
                return const SignInPage();
              case 'sign_in':
                return const SignInPage();
              case 'sign_up':
                return const SignUpPage();
              case 'pass_reset':
                return const PassResetPage();
              case 'lobby':
                return const LobbyPage();
              default:
                return const SignInPage();
            }
          },
        );
      },
      navigatorObservers: [MyNavigatorObserver()],
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Проверка на переход из адресной строки
    if (previousRoute != null && route.settings.name != previousRoute.settings.name) {
      print("Attempted navigation via address bar prevented!");
      Navigator.of(route.navigator!.context).pop();
    }
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