import 'package:csan/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Панель администратора',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Align(
          alignment: const AlignmentDirectional(0.00, 0.00),
          child: SingleChildScrollView(
            child: buildAdminPanelForm(context),
          ),
        ),
      ),
    );
  }

  // общий вид страницы панели администратора
  Widget buildAdminPanelForm(BuildContext context) {
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
          color: Colors.white,
        ),
        child: Align(
          alignment: const AlignmentDirectional(0.00, 0.00),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32, 10, 32, 32),
            child: buildAdminPanelContainer(context),
          ),
        ),
      ),
    );
  }

  // контейнер с виджетами на странице панели администратора
  Widget buildAdminPanelContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 600,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: buildFormFields(context),
    );
  }

  // форма виджетов на странице панели администратора
  Widget buildFormFields(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(context),
        buildSetDefaultRolePageButton(context),
        buildLobbyPageButton(context),
      ],
    );
  }

  // виджет текста "Панель администратора"
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

  // виджет кнопки перехода на страницу редактирования прав новых пользователей
  Widget buildSetDefaultRolePageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ПРАВА НОВЫХ ПОЛЬЗОВАТЕЛЕЙ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "default_role");
      },
    );
  }

  // виджет кнопки возврата на страницу лобби
  Widget buildLobbyPageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ВЕРНУТЬСЯ В ЛОББИ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "lobby");
      },
    );
  }
}