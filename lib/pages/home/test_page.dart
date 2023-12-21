import 'package:csan/service/auth/firebase_auth_service.dart';
import 'package:csan/widgets/edit_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late final FirebaseAuthService _authService = FirebaseAuthService();

  String rightRole = 'administrator';

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

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'тест',
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
              child: checkingForPrivilegRole(context, rightRole),
            ),
          ),
        ),
      ),
    );
  }

  // отрисовка страницы заказов осуществляется на основе прав пользователей
  FutureBuilder<bool> checkingForPrivilegRole(BuildContext context, String rightRole) {
    return FutureBuilder<bool>(
      future: _authService.isItRightRole(rightRole),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          // показываем анимацию загрузки, если привилегированная роль не обнаружена
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // проверяем результат и строим виджеты в зависимости от него
        if (snapshot.data == true) {

          // если привилегированная роль обнаружена, показываем полную страницу
          return buildFullPage(context);
        } else {

          // если привилегированная роль не обнаружена, показываем страницу без кнопки создания нового заказа
          return buildPageWithoutCreateButton(context);
        }
      },
    );
  }

  // отрисовка страницы заказов для пользователя с полным доступом
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
                  buildHeader(context),
                  buildOrderHeader(context),
                  customStreamBuilder(context),
                  emptyTextWidget(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: Center(
            child: buildCreateNewOrderButton(context),
          ),
        ),
      ],
    );
  }

  // отрисовка страницы заказов для пользователя без права доступа к изменению БД
  Widget buildPageWithoutCreateButton(BuildContext context) {
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
              buildHeader(context),
              buildOrderHeader(context),
              customStreamBuilder111(context),
              emptyTextWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /*
  // метод для автоматической подгрузки виджетов заказов из базы данных с кликабельными полями
  Widget customStreamBuilder(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('orders').orderBy('number').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyTextWidget(); // Показываем текст, если данных нет
        }

        // Если данные есть, обрабатываем их
        List<Widget> orderWidgets = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          // Получаем данные из документа (парсим)
          String amount = doc['amount'];
          String date = doc['date'];
          int number = doc['number'];
          String state = doc['state'];
          String weight = doc['weight'];

          // Добавляем виджет с данными в список
          orderWidgets.add(buildOrderCard(context, doc, amount, date, number, state, weight));
        }

        // Возвращаем список виджетов
        return Column(
          children: orderWidgets,
        );
      },
    );
  }
  */

  // метод для автоматической подгрузки виджетов заказов из базы данных с кликабельными полями
  Widget customStreamBuilder(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('orders').orderBy('number').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyTextWidget(); // Показываем текст, если данных нет
        }

        // Если данные есть, обрабатываем их
        List<Widget> orderWidgets = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          // Получаем данные из документа (парсим)
          String amount = doc['amount'];
          String date = doc['date'];
          int number = doc['number'];
          String state = doc['state'];
          String weight = doc['weight'];

          // Добавляем виджет с данными в список
          orderWidgets.add(buildClickableOrderCard(context, doc, amount, date, number, state, weight));
        }

        // Возвращаем список виджетов
        return Column(
          children: orderWidgets,
        );
      },
    );
  }

  Widget customStreamBuilder111(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('orders').orderBy('number').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyTextWidget(); // Показываем текст, если данных нет
        }

        // Если данные есть, обрабатываем их
        List<Widget> orderWidgets = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          // Получаем данные из документа (парсим)
          String amount = doc['amount'];
          String date = doc['date'];
          int number = doc['number'];
          String state = doc['state'];
          String weight = doc['weight'];

          // Добавляем виджет с данными в список
          orderWidgets.add(buildNonClickableOrderCard(context, doc, amount, date, number, state, weight));
        }

        // Возвращаем список виджетов
        return Column(
          children: orderWidgets,
        );
      },
    );
  }

  Widget buildFirstButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            24, 0, 0, 10),
        child: ElevatedButton(
          onPressed: (){
            print('Button pressed ...');
            Navigator.pushReplacementNamed(context, "lobby");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 3,
          ),
          child: Text(
            'Назад',
            style: GoogleFonts.outfit(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // виджет кнопки для создания нового заказа
  Widget buildCreateNewOrderButton(BuildContext context) {
    return Align(
      //alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(70, 0, 70, 0), // Изменил отступы
        child: ElevatedButton(
          onPressed: () async {
            //print('Button pressed ...');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const EditOrderDialog();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // устанавливаем радиус закругления
            ),
            minimumSize: const Size(double.infinity, 55), // растягиваем кнопку по ширине
          ),
          child: Text(
            'ДОБАВИТЬ НОВЫЙ ЗАКАЗ',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }


  Widget buildWarehouseNameText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 24, 0),
        child: Text(
          'Пункт №NaN',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildCityNameText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 24, 0),
        child: Text(
          'г. NaN',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildStreetNameText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 24, 5),
        child: Text(
          'ул. NaN, д. NaN',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // шапка навигационного меню
  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildFirstButton(context),
          ],
        ),
        Expanded(
          child: Align(
            alignment: const AlignmentDirectional(1, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                buildWarehouseNameText(context),
                buildCityNameText(context),
                buildStreetNameText(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // шапка над списком заказов
  Widget buildOrderHeader(BuildContext buildContext) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                flex: 4,
                child: Text(
                  'Номер заказа',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (screenWidth > 650) // ограничение по минимальной ширине
                Expanded(
                  flex: 1,
                  child: Text(
                    'Вес',
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (screenWidth > 650) // ограничение по минимальной ширине
                Expanded(
                  flex: 2,
                  child: Text(
                    'Статус заказа',
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: Text(
                  'Стоимость',
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


  // добавляет пустое поле внизу страницы
  Widget emptyTextWidget() {
    return const Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 25),
      child: Text(''),
    );
  }

  // возврат кликабельных карточек заказов
  Widget buildClickableOrderCard(BuildContext context, QueryDocumentSnapshot doc, String amount, String date, int number, String state, String weight) {
    return InkWell(
      onTap: () async {
        bool isAdministrator = await _authService.isItRightRole(rightRole);
        if (isAdministrator) {
          String documentId = doc.id;
          print('Document ID: $documentId');
          print("button pressed");
        } else {
          print("Роль не совпадает");
        }
      },
      child: _buildOrderCard(context, amount, date, number, state, weight),
    );
  }

  // возврат некликабельных карточек заказов
  Widget buildNonClickableOrderCard(BuildContext context, QueryDocumentSnapshot doc, String amount, String date, int number, String state, String weight) {
    return _buildOrderCard(context, amount, date, number, state, weight);
  }

  // виджет карточек заказов
  Widget _buildOrderCard(BuildContext context, String amount, String date, int number, String state, String weight) {
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
                flex: 4,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText(context, number),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          date,  // дата из БД
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
              if (MediaQuery.of(context).size.width > 650)
                Expanded(
                  flex: 1,
                  child: _buildContainer('$weight г', const Color(0xFFF1F4F8)),
                ),
              if (MediaQuery.of(context).size.width > 650)
                Expanded(
                  flex: 2,
                  child: _buildContainer(state, const Color(0x4D9489F5)),
                ),
              Expanded(
                flex: 2,
                child: _buildColumn(context, amount, state),
              ),
            ],
          ),
        ),
      ),
    );
  }




/*
  // виджет карточки заказа
  Widget buildOrderCard(BuildContext context, QueryDocumentSnapshot doc, String amount, String date, int number, String state, String weight) {

    String amount = doc['amount'];
    String date = doc['date'];
    int number = doc['number'];
    String state = doc['state'];
    String weight = doc['weight'];

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
                flex: 4,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRichText(context, number),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          date,  // дата из БД
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
              if (MediaQuery.of(context).size.width > 650)
                Expanded(
                  flex: 1,
                  child: _buildContainer('$weight г', const Color(0xFFF1F4F8)),
                ),
              if (MediaQuery.of(context).size.width > 650)
                Expanded(
                  flex: 2,
                  child: _buildContainer(state, const Color(0x4D9489F5)),
                ),
              Expanded(
                flex: 2,
                child: _buildColumn(context, amount, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

 */

  Widget _buildRichText(BuildContext context, int number) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Заказ №: ',
            style: TextStyle(),
          ),
          TextSpan(
            text: number.toString(),
            style: const TextStyle(
              color: Color(0xFF6F61EF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        style: GoogleFonts.montserrat(
          color: const Color(0xFF15161E),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContainer(String text, Color color) {
    return SizedBox(
      height: 32,
      // decoration: BoxDecoration(
      //   color: color,
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(
      //     color: borderColor,
      //     width: 2,
      //   ),
      // ),
      child: Align(
        alignment: const AlignmentDirectional(0, 0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 7, 0),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF606A85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String amount, String state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'BYN $amount',
          textAlign: TextAlign.end,
          style: GoogleFonts.montserrat(
            color: const Color(0xFF15161E),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (MediaQuery.of(context).size.width <= 650)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            child: _buildContainer(state, const Color(0x4D9489F5)),
          ),
      ],
    );
  }
}