import 'package:csan/pages/home/test_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/auth/sign_in_page.dart';
import 'pages/auth/sign_up_page.dart';
import 'pages/auth/pass_reset_page.dart';
import 'pages/home/lobby_page.dart';
import 'pages/home/table_test_page.dart';

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
              case 'test':
                return const TestPage();
              case 'table':
                return const MyTablePage();
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

// метод, который следит за переходами между страницами
class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Проверка на переход из адресной строки
    if (previousRoute != null && route.settings.name != previousRoute.settings.name) {
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