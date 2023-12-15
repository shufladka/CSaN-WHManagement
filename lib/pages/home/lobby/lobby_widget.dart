import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lobby_model.dart';

class LobbyWidget extends StatefulWidget {
  const LobbyWidget({Key? key}) : super(key: key);

  @override
  _LobbyWidgetState createState() => _LobbyWidgetState();
}

class _LobbyWidgetState extends State<LobbyWidget> {
  late LobbyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // значение чекбокса по умолчанию
  bool checkBoxDefaultState = false;

  @override
  void initState() {
    super.initState();
    _model = LobbyModel();

    _model.t1Controller ??= TextEditingController();
    _model.t1FocusNode ??= FocusNode();

    _model.t2Controller ??= TextEditingController();
    _model.t2FocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'sign_in',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
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
      height: MediaQuery.of(context).size.height * 1,
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: 600,
      ),
      decoration: BoxDecoration(
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

        buildTestButton(context),
        /*
        buildEmailField(context),
        buildPasswordField(context),
        buildRememberMeCheckbox(context),
        buildSignInButton(context),
        buildRegistrationLink(context),
        buildForgotPasswordButton(context),
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
            //child: buildFormFields(context),
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
          'ГЛАВНОЕ МЕНЮ',
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




  Widget buildTestButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Вызываем метод для валидации формы
            //validateForm(context);
            print('pressed');
            Navigator.of(context).pushNamed('sign_in');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Заменил на классический цвет
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Убираем закругления
            ),
          ),
          child: Text(
            'ВЫЙТИ',
            style: GoogleFonts.montserrat(
              color: Colors.white, // Заменил на классический цвет
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }





  Widget buildEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: _model.t1Controller,
        focusNode: _model.t1FocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: buildInputDecoration(context, 'почтовый адрес или псевдоним'),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).primaryColor,
        validator: (value) => _model.validate(value, 't1'),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: _model.t2Controller,
        focusNode: _model.t2FocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: !_model.t2Visibility,
        decoration: buildPasswordInputDecoration(context),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black45,
        validator: (value) => _model.validate(value, 't1'),
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.montserrat(
        color: const Color(0x6222282F),
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }

  InputDecoration buildPasswordInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'пароль',
      hintStyle: GoogleFonts.montserrat(
        color: const Color(0x6222282F),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xB1F1F4F8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      suffixIcon: InkWell(
        onTap: () => setState(() => _model.t2Visibility = !_model.t2Visibility),
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          _model.t2Visibility
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget buildRememberMeCheckbox(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            unselectedWidgetColor: Colors.black,
          ),
          child: Checkbox(

            // значение чекбокса по умолчанию - не нажата
            value: _model.checkboxValue ??= checkBoxDefaultState,
            onChanged: (newValue) async {
              setState(() => _model.checkboxValue = newValue!);
            },
            activeColor: Colors.black,
            checkColor: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
          child: Text(
            'запомнить меня',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Вызываем метод для валидации формы
            validateForm(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87, // Заменил на классический цвет
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Убираем закругления
            ),
          ),
          child: Text(
            'ВОЙТИ',
            style: GoogleFonts.montserrat(
              color: Colors.white, // Заменил на классический цвет
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Метод для валидации формы
  void validateForm(BuildContext context) {
    // Проверяем, пуста ли форма
    if (_model.isFormEmpty()) {
      // Если форма пуста, выведем ошибку (можно использовать SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Заполните все поля формы.',
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
          backgroundColor: Colors.red,
        ),
      );
      // Прекращаем выполнение метода
      return;
    }

    // Проверяем, совпадают ли пароль и подтверждение пароля
    if (_model.t1Controller!.text.length < 10) {
      // Если не совпадают, выведем ошибку (можно использовать SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Длина почтового адреса должна составлять не менее 10 символов.',
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
          backgroundColor: Colors.red,
        ),
      );
      // Прекращаем выполнение метода
      return;
    }

    // Проверяем, совпадают ли пароль и подтверждение пароля
    if (_model.t2Controller!.text.length < 6) {
      // Если не совпадают, выведем ошибку (можно использовать SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Длина пароля должна составлять не менее 6 символов.',
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
          backgroundColor: Colors.red,
        ),
      );
      // Прекращаем выполнение метода
      return;
    }

    // дописать код для обработки создания аккаунта
    print('Button pressed ...');
  }

  Widget buildRegistrationLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
              child: Text(
                'у вас ещё нет аккаунта?',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF2E373C),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 2, 0, 1),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.of(context).pushNamed('sign_up');
                },
                child: Text(
                  'регистрация',
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForgotPasswordButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('sign_reset');
            },
            child: Container(
              color: Colors.white, // Белый фон
              //padding: EdgeInsets.all(12),
              child: Text(
                'забыли пароль?',
                textAlign: TextAlign.center, // Выравнивание по центру
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Цвет текста
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
