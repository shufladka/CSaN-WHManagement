import 'package:csan/service/auth/firebase_auth_service.dart';
import 'package:csan/widgets/order_dialog_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late final FirebaseAuthService _authService = FirebaseAuthService();

  // инициализация переменных для хранения имен прав привилегированных пользователей
  String adminRole = 'administrator';
  String salespersonRole = 'salesperson';

  // подключение к базе данных Firestore Database
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
      title: 'Список заказов',
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

      // проверка на принадлежность пользователя к привилегии "Администратор"
      future: _authService.isItRightRole(adminRole),
      builder: (context, adminSnapshot) {
        if (adminSnapshot.connectionState == ConnectionState.waiting) {

          // показываем анимацию загрузки, если привилегированная роль не обнаружена
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // проверяем результат и строим страницу в соответствии с привилегией
        if (adminSnapshot.data == true) {

          // если привилегированная роль "Администратор" обнаружена, показываем полную страницу
          return buildFullPage(context);
        } else {

          // если привилегированная роль "Администратор" не обнаружена, проверяем на принадлежность к привилегии "Продавец"
          return FutureBuilder<bool>(
            future: _authService.isItRightRole(salespersonRole),
            builder: (context, salespersonSnapshot) {
              if (salespersonSnapshot.connectionState == ConnectionState.waiting) {

                // показываем анимацию загрузки, если привилегированная роль не обнаружена
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // проверяем результат и строим страницу в соответствии с привилегией
              if (salespersonSnapshot.data == true) {

                // если привилегированная роль "Продавец" обнаружена, показываем страницу без кнопки создания нового заказа
                return buildPageWithoutCreateButton(context);
              } else {

                // если привилегии не обнаружены, показываем страницу с просьбой обратиться к администратору
                return buildPageWithoutAnything(context);
              }
            },
          );
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

        // отрисовка кнопки для создания нового заказа
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

  // отрисовка страницы заказов для пользователя группы "Продавец"
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
              customStreamBuilder(context),
              emptyTextWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // отрисовка страницы заказов для пользователя без доступа к базе данных
  Widget buildPageWithoutAnything(BuildContext context) {
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
              buildErrorWithOrdersPageButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // отрисовка списка заказов для пользователя без доступа к базе данных
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

  // метод для автоматической подгрузки виджетов заказов из базы данных с кликабельными полями
  Widget customStreamBuilder(BuildContext context) {
    return StreamBuilder(

      // получение списка таблиц заказов из коллекции 'orders', отсортированного по номеру заказа
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

        // показываем пустое поле, если данных нет
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyTextWidget();
        }

        // если данные есть, обрабатываем их
        List<Widget> orderWidgets = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {

          // получаем (парсим) данные из документа
          String amount = doc['amount'];
          String date = doc['date'];
          int number = doc['number'];
          String state = doc['state'];
          String weight = doc['weight'];

          // добавляем виджет с данными в список заказов
          orderWidgets.add(buildClickableOrderCard(context, doc, amount, date, number, state, weight));
        }

        // возвращаем список виджетов
        return Column(children: orderWidgets);
      },
    );
  }

  // виджет для отрисовки кнопки возврата в меню
  Widget buildReturnButton(BuildContext context) {
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
            backgroundColor: Colors.red[700],
            elevation: 3,
            shape: RoundedRectangleBorder(

              // устанавливаем радиус закругления бортов кнопки
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'НАЗАД',
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

  // виджет кнопки для создания нового заказа
  Widget buildCreateNewOrderButton(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(70, 0, 70, 0),
        child: ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const CreateOrderDialog();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            elevation: 3,
            shape: RoundedRectangleBorder(

              // устанавливаем радиус закругления бортов кнопки
              borderRadius: BorderRadius.circular(8),
            ),

            // растягиваем кнопку по ширине
            minimumSize: const Size(double.infinity, 55),
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

  // виджет для отрисовки текста "номер пункта выдачи"
  Widget buildWarehouseNameText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 24, 0),
        child: Text(
          'Пункт №42',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // виджет для отрисовки текста "город"
  Widget buildCityNameText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 24, 0),
        child: Text(
          'г. Солигорск',
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // виджет для отрисовки текста "улица/дом"
  Widget buildStreetNameText(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 24, 5),
        child: Text(
          'ул. Богомолова, д. 2',
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
            buildReturnButton(context),
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
                flex: 8,
                child: Text(
                  'Номер заказа',
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // ограничение по минимальной ширине
              if (screenWidth > 650)
                Expanded(
                  flex: 2,
                  child: Text(
                    'Вес',
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // ограничение по минимальной ширине
              if (screenWidth > 650)
                Expanded(
                  flex: 4,
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
                flex: 3,
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

  // возврат кликабельных карточек заказов для пользователей группы "Администратор" или группы "Продавец"
  Widget buildClickableOrderCard(BuildContext context, QueryDocumentSnapshot doc, String amount, String date, int number, String state, String weight) {
    return InkWell(
      onTap: () async {
        bool isAdministrator = await _authService.isItRightRole(adminRole);
        bool isSalesperson = await _authService.isItRightRole(salespersonRole);

        if (isAdministrator) {
          String documentId = doc.id;
          print('Document ID: $documentId');
          print("button pressed");

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditOrderDialog(docID: doc.id, docNumber: number);
            },
          );

        } else if (isSalesperson) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditOrderStateDialog(docID: doc.id, docNumber: number);
            },
          );
        } else {
          print("Роль не совпадает");
        }

      },
      child: buildOrderCard(context, amount, date, number, state, weight),
    );
  }

  // возврат некликабельных карточек заказов
  Widget buildNonClickableOrderCard(BuildContext context, String amount, String date, int number, String state, String weight) {
    return buildOrderCard(context, amount, date, number, state, weight);
  }

  // виджет карточек заказов
  Widget buildOrderCard(BuildContext context, String amount, String date, int number, String state, String weight) {
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
                      buildOrderNumberText(context, number),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          date,  // дата из базы данных
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
                  child: buildWeightAndStateText('$weight г'),
                ),
              if (MediaQuery.of(context).size.width > 650)
                Expanded(
                  flex: 2,
                  child: buildWeightAndStateText(state),
                ),
              Expanded(
                flex: 2,
                child: buildAmountText(context, amount, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // виджет для отрисовки номера заказа
  Widget buildOrderNumberText(BuildContext context, int number) {
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

  // виджет для отрисовки веса и состояния заказа
  Widget buildWeightAndStateText(String text) {
    return SizedBox(
      height: 32,
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

  // виджет для отрисовки стоимости заказа
  Widget buildAmountText(BuildContext context, String amount, String state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$amount BYN',
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
            child: buildWeightAndStateText(state),
          ),
      ],
    );
  }
}