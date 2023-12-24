import 'package:csan/service/auth/clear_user_data_service.dart';
import 'package:csan/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String adminRole = 'administrator';

  @override
  void initState() {
    super.initState();
  }

  // Метод для вызова удаления сохраненных данных
  Future<void> _clearSavedData() async {
    await ClearUserData().clearSavedData();
  }

  // Вызов метода для очистки сохраненных данных и выхода из аккаунта
  void _clearUserData() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "sign_in");
    _clearSavedData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Лобби',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Align(
          alignment: const AlignmentDirectional(0.00, 0.00),
          child: SingleChildScrollView(
            child: buildSignInForm(context),
          ),
        ),
      ),
    );
  }

  Widget buildSignInContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 600,
      ),
      decoration: const BoxDecoration(
        color: Colors.white, // Заменил на классический цвет
      ),
      child: buildFormFields(context),
    );
  }

  Widget buildFormFields(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(context),
        buildClearUserDataButton(context),
        buildSubmitButton(context),
        buildOrdersPageButton(context),

        buildAdminPanelPageButton(context),

        buildLobbyTestPageButton(context),
        /*
        // проверка на принадлежность пользователя к привилегированной группе
        FutureBuilder<bool>(
          future: _authService.isItadminRole(adminRole),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.data != true) {
              return const SizedBox(); // Показываем пустой контейнер, если привилегированная роль не обнаружена
            }
            return buildAdminPanelPageButton(context);
          },
        ),

         */
      ],
    );
  }

  Widget buildSignInForm(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 600,
        ),
        decoration: const BoxDecoration(
          color: Colors.white, // Use your desired color
        ),
        child: Align(
          alignment: const AlignmentDirectional(0.00, 0.00),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32, 10, 32, 32),
            child: buildSignInContainer(context),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
        child: Text(
          'ЛОББИ',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            letterSpacing: 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ПЕРЕЙТИ В МЕНЮ АУТЕНТИФИКАЦИИ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "sign_in");
      },
    );
  }

  Widget buildClearUserDataButton(BuildContext context) {
    return BuildExitButtonWidget(
      buttonText: 'ЗАБЫТЬ ДАННЫЕ ДЛЯ ВХОДА',
      onPressed: () {
        _clearUserData();
      },
    );
  }

  Widget buildOrdersPageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ПЕРЕЙТИ В МЕНЮ ЗАКАЗОВ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "orders");
      },
    );
  }

  Widget buildAdminPanelPageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ПАНЕЛЬ АДМИНИСТРАТОРА',
      onPressed: () {
        //Navigator.pushReplacementNamed(context, "test");
        //print(FirebaseAuth.instance.currentUser!.displayName);
        Navigator.pushReplacementNamed(context, "admin_panel");
      },
    );
  }

  Widget buildLobbyTestPageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ТЕСТОВАЯ СТРАНИЦА',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "test");
      },
    );
  }
}
