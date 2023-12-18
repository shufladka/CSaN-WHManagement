import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'test page',
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            buildOrderCard(context),
                            emptyTextWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            24, 0, 0, 10),
        child: ElevatedButton(
          onPressed: () {
            print('Button pressed ...');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 3,
          ),
          child: Text(
            'Выйти',
            style: GoogleFonts.outfit(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSecondButton(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            24, 0, 0, 0),
        child: ElevatedButton(
          onPressed: () {
            print('Button pressed ...');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 3,
          ),
          child: Text(
            'Выйти',
            style: GoogleFonts.outfit(
              color: Colors.white,
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
            buildSecondButton(context),
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
      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
      child: Text(''),
    );
  }


  Widget buildOrderCard(BuildContext context) {
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
                      _buildRichText(context),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          'Пн, 03.07.2023',
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
                  child: _buildContainer('2,5 кг', const Color(0xFFF1F4F8)),
                ),
              if (MediaQuery.of(context).size.width > 650)
                Expanded(
                  flex: 2,
                  // child: _buildContainer('Shipped', const Color(0x4D9489F5), const Color(0xFF6F61EF)),
                  child: _buildContainer('Отправлено', const Color(0x4D9489F5)),
                ),
              Expanded(
                flex: 2,
                child: _buildColumn(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: const [
          TextSpan(
            text: 'Заказ №: ',
            style: TextStyle(),
          ),
          TextSpan(
            text: '124',
            style: TextStyle(
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

  Widget _buildColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'BYN 150',
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
            child: _buildContainer('Отправлено', const Color(0x4D9489F5)),
          ),
      ],
    );
  }


}
