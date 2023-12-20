import 'package:csan/widgets/edit_order_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final unfocusNode = FocusNode();

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
    unfocusNode.dispose();
    super.dispose();
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'test',
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          if (unfocusNode.canRequestFocus) {
            FocusScope.of(context).requestFocus(unfocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
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
                child: Stack(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 1170,
                            minWidth: 360,
                          ),
                          decoration: const BoxDecoration(),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

   */
  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'test',
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          if (unfocusNode.canRequestFocus) {
            FocusScope.of(context).requestFocus(unfocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
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
                child: Stack(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 1170,
                            minWidth: 360,
                          ),
                          decoration: const BoxDecoration(),
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
                    ),

                    // добавление новых заказов доступно только администратору
                    // if (FirebaseAuth.instance.currentUser!.displayName == 'administrator')
                    //if (FirebaseAuth.instance.currentUser!.displayName == 'administrator' || FirebaseAuth.instance.currentUser!.displayName == 'user')
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Center(
                          child: buildCreateNewOrderButton(context),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  // метод для автоматической подгрузки виджетов заказов из базы данных
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


  // виджет карточки заказа
  Widget buildOrderCard(BuildContext context, QueryDocumentSnapshot doc, String amount, String date, int number, String state, String weight) {

    String amount = doc['amount'];
    String date = doc['date'];
    int number = doc['number'];
    String state = doc['state'];
    String weight = doc['weight'];

    return InkWell(
      onTap: () {
        // обработка нажатия на виджет заказа
        /*
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const EditOrderDialog();
          },
        );

         */
        String documentId = doc.id;
        print('Document ID: $documentId');
        //print("button pressed");
      },



      child: Padding(
    //return Padding(
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
      ),
    );
  }


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