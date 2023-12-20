import 'package:csan/service/auth/clear_user_data_service.dart';
import 'package:csan/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final unfocusNode = FocusNode();


  @override
  void initState() {
    super.initState();

    unfocusNode.addListener(() {
      if (unfocusNode.hasFocus) {
        unfocusNode.unfocus();
      }
    });
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
    unfocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Панель администратора',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: GestureDetector(
        onTap: () => unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(unfocusNode)
            : FocusScope.of(context).unfocus(),
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
        getDisplayCurrentUserNameButton(context),
        buildLobbyPageButton(context),

        //buildClearUserDataButton(context),
        //buildSubmitButton(context),
        //buildTestButton(context),
        //getNewNameToCurrentUserButton(context),
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
          'ПАНЕЛЬ АДМИНИСТРАТОРА',
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

  Widget buildLobbyPageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ВЕРНУТЬСЯ В ЛОББИ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "lobby");
      },
    );
  }

  Widget getDisplayCurrentUserNameButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ПРАВА НОВЫХ ПОЛЬЗОВАТЕЛЕЙ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "default_role");
        //print(FirebaseAuth.instance.currentUser!.displayName);

      },
    );
  }

/*
  Widget getNewNameToCurrentUserButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ДАТЬ ПРАВА АДМИНИСТРАТОРА',
      onPressed: () {
        //Navigator.pushReplacementNamed(context, "test");
        setDisplayName('administrator');
      },
    );
  }

  void setDisplayName(String displayName) async {
    try {
      // Получаем текущего пользователя
      User? user = FirebaseAuth.instance.currentUser;

      // Обновляем профиль пользователя с новым displayName
      await user?.updateProfile(displayName: displayName);

      // Обновляем информацию о пользователе в Firestore или другом месте, где хранятся данные пользователя

      // Печатаем успешное сообщение
      print('displayName успешно обновлен: $displayName');
    } catch (e) {
      // Обработка ошибок при установке displayName
      print('Ошибка при обновлении displayName: $e');
    }
  }

   */
}