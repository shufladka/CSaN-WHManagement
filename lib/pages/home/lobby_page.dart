import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csan/service/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csan/service/auth/clear_user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late final FirebaseAuthService _authService = FirebaseAuthService();
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late final FirebaseFirestore _database = FirebaseFirestore.instance;

  String adminRole = 'administrator';
  String salespersonRole = 'salesperson';

  // подключение к базе данных Firebase
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    return Title(
      title: 'Лобби',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 1170, // Set your desired maximum width
              ),
              child: checkingForPrivilegedRole(context),
            ),
          ),
        ),
      ),
    );
  }

  // проверка на привилегированную роль пользователя
  FutureBuilder<bool> checkingForPrivilegedRole(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isItRightRole(adminRole), // Проверка adminRole
      builder: (context, adminSnapshot) {
        if (adminSnapshot.connectionState == ConnectionState.waiting) {
          // Показываем анимацию загрузки, если привилегированная роль не обнаружена
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Проверяем результат и строим виджеты в зависимости от него
        if (adminSnapshot.data == true) {
          // Если привилегированная роль adminRole обнаружена, показываем полную страницу
          return buildFullPage(context);
        } else {
          // Если привилегированная роль adminRole не обнаружена, проверяем salespersonRole
          return FutureBuilder<bool>(
            future: _authService.isItRightRole(salespersonRole),
            builder: (context, salespersonSnapshot) {
              if (salespersonSnapshot.connectionState == ConnectionState.waiting) {
                // Показываем анимацию загрузки, если привилегированная роль не обнаружена
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Проверяем результат и строим виджеты в зависимости от него
              if (salespersonSnapshot.data == true) {
                // Если привилегированная роль salespersonRole обнаружена, показываем полную страницу
                return buildPageWithoutAdminPanelButton(context);
              } else {
                // Если ни adminRole, ни salespersonRole не обнаружены, показываем страницу без кнопки создания нового заказа
                return buildPageWithoutAnythingButton(context);
              }
            },
          );
        }
      },
    );
  }


  // отрисовка страницы меню для пользователя с полным доступом
  Widget buildFullPage(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const AlignmentDirectional(0, -1),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 1170,
              minWidth: 360,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFullHeader(context),
                  buildOrderHeader(context),
                  buildClickableOrdersPageButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // отрисовка страницы меню для пользователя без доступа к панели администратора
  Widget buildPageWithoutAdminPanelButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 1170,
          minWidth: 360,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCroppedHeader(context),
              buildOrderHeader(context),
              buildClickableOrdersPageButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // отрисовка страницы меню для пользователя без права доступа к базе данных
  Widget buildPageWithoutAnythingButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, -1),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 1170,
          minWidth: 360,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCroppedHeader(context),
              buildErrorWithOrdersPageButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // шапка навигационного меню
  Widget buildFullHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildClearUserDataButton(context),
            buildReturnButton(context),
            buildAdminPanelPageButton(context),
          ],
        ),
        Expanded(
          child: Align(
            alignment: const AlignmentDirectional(1, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildEmailNameText(context),
                buildCurrentRoleNameText(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // шапка навигационного меню
  Widget buildCroppedHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildClearUserDataButton(context),
            buildReturnButton(context),
          ],
        ),
        Expanded(
          child: Align(
            alignment: const AlignmentDirectional(1, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildEmailNameText(context),
                buildCurrentRoleNameText(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildClearUserDataButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            24, 20, 0, 10),
        child: ElevatedButton(
          onPressed: (){
            print('Button pressed ...');
            _clearUserData();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // устанавливаем радиус закругления
            ),
          ),
          child: Text(
            'ЗАБЫТЬ МЕНЯ',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReturnButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            24, 0, 0, 10),
        child: ElevatedButton(
          onPressed: (){
            print('Button pressed ...');
            Navigator.pushReplacementNamed(context, "sign_in");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // устанавливаем радиус закругления
            ),
          ),
          child: Text(
            'ВЫЙТИ',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // виджет для отображения кнопки перехода в панель администратора
  Widget buildAdminPanelPageButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            24, 0, 0, 10),
        child: ElevatedButton(
          onPressed: (){
            print('Button pressed ...');
            Navigator.pushReplacementNamed(context, "admin_panel");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // устанавливаем радиус закругления
            ),
          ),
          child: Text(
            'ПАНЕЛЬ АДМИНИСТРАТОРА',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // виджет для отображения почтового адреса текущего пользователя
  Widget buildEmailNameText(BuildContext context) {
    return FutureBuilder<String>(
      future: _authService.getCurrentUserEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          // отображаем индикатор загрузки во время ожидания данных
          return const Align(
            alignment: AlignmentDirectional(1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          String email = snapshot.data ?? '';

          return Align(
            alignment: const AlignmentDirectional(1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
              child: Text(
                email,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // виджет для отображения роли текущего пользователя
  Widget buildCurrentRoleNameText(BuildContext context) {
    return FutureBuilder<String?>(
      future: _authService.getUserRole(_auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          // отображаем индикатор загрузки во время ожидания данных
          return const Align(
            alignment: AlignmentDirectional(1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 24, 5),
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          String currentRole = snapshot.data ?? '';

          return Align(
            alignment: const AlignmentDirectional(1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 24, 5),
              child: Text(
                currentRole,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // шапка над списком пунктов выдачи
  Widget buildOrderHeader(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 10),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black87,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Пункт выдачи',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Заказов в обороте',
                  textAlign: TextAlign.end,
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // возврат кликабельной страницы заказов
  Widget buildClickableOrdersPageButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool isAdministrator = await _authService.isItRightRole(adminRole);
        bool isSalesperson = await _authService.isItRightRole(salespersonRole);

        if (isAdministrator || isSalesperson) {
          Navigator.pushReplacementNamed(context, "orders");
          print("button pressed");

        } else {
          print("Роль не совпадает");
        }
      },
      child: buildOrdersPageButton(context),
    );
  }

  // отрисовка списка пунктов выдачи
  Widget buildOrdersPageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Пункт №42',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF15161E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // местоположение пункта выдачи
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          "г. Солигорск, ул. Богомолова, д. 2",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF606A85),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: buildNumberOfOrdersText(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // виджет для отображения оборота заказов
  Widget buildNumberOfOrdersText(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _database.collection('technical_information').doc('number_of_orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          // отображаем индикатор загрузки во время ожидания данных
          return const Align(
            alignment: AlignmentDirectional(1, 0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
              child: CircularProgressIndicator(),
            ),
          );

        } else {
          // Получаем значение number_of_orders из поля number_of_orders
          int numberOfOrders = snapshot.data?['number_of_orders'] ?? '';

          return Align(
            alignment: const AlignmentDirectional(1, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
              child: Text(
                '$numberOfOrders ед.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF15161E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // отрисовка списка пунктов выдачи обычному пользователю
  Widget buildErrorWithOrdersPageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 16, 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                child: Text(
                  "ДАННЫЕ НЕДОСТУПНЫ. ОБРАТИТЕСЬ К АДМИНИСТРАТОРУ",
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF161718),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}