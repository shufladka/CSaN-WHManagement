import 'package:csan/service/auth/firebase_auth_service.dart';
import 'package:csan/service/auth/form_validation_service.dart';
import 'package:csan/widgets/input_decoration_widget.dart';
import 'package:csan/widgets/submit_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassResetPage extends StatefulWidget {
  const PassResetPage({super.key});

  @override
  _PassResetPageState createState() => _PassResetPageState();
}

class _PassResetPageState extends State<PassResetPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // переменная для скрытия клавиатуры нажатием по пустому полю
  final unfocusNode = FocusNode();

  FocusNode? emailFocusNode;
  TextEditingController? emailController;

  final FirebaseAuthService _auth = FirebaseAuthService();

  // обработка перехода через вызов сервиса аутентификации
  void _passwordReset() async {

    String email = emailController!.text;

    User? user = await _auth.resetPassword(context, email);

    if (user != null) {
      print('user is successfully created.');
      Navigator.pushReplacementNamed(context, "sign_in");
    } else {
      print('some happend :(');
      Navigator.pushReplacementNamed(context, "sign_in");
    }
  }

  @override
  void initState() {
    super.initState();

    emailController ??= TextEditingController();
    emailFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    unfocusNode.dispose();
    emailFocusNode?.dispose();
    emailController?.dispose();
  }

  // проверка на пустую форму
  bool isFormEmpty() {
    if (emailController!.text.isEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Сброс пароля',
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
              child: buildPassResetForm(context),
            ),
          ),
        ),
      ),
    );
  }

  // контейнер с содержимым страницы сброса пароля
  Widget buildPassResetContainer(BuildContext context) {
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

  // содержимое формы страницы сброса пароля
  Widget buildFormFields(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(context),
        buildEmailField(context),
        buildSubmitButton(context),
        buildReturnButton(context),
      ],
    );
  }

  // форма страницы сброса пароля
  Widget buildPassResetForm(BuildContext context) {
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
            child: buildPassResetContainer(context),
          ),
        ),
      ),
    );
  }

  // текстовое поле заголовка страницы сброса пароля
  Widget buildTitle(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
        child: Text(
          'СБРОС ПАРОЛЯ',
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

  // виджет поля ввода почтового адреса для отправки на него формы восстановления пароля
  Widget buildEmailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: emailController,
        focusNode: emailFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: InputDecorationBuilder.buildInputDecoration(context, 'почтовый адрес'),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // виджет кнопки отправки формы в базу данных аутентификации
  Widget buildSubmitButton(BuildContext context) {

    // экземпляр класса валидации формы регистрации нового пользователя
    CustomFormValidator formValidator = CustomFormValidator(
      emailController: emailController,
      passwordController: null,
      confirmPasswordController: null,
      needPassword: false,
      needConfirmPassword: false,
    );

    return BuildButtonWidget(
      buttonText: 'ОТПРАВИТЬ ПАРОЛЬ',
      onPressed: () {
        
        // если форма валидна, переходим к странице входа в аккаунт
        if (formValidator.validateForm(context)) {
          _passwordReset();
        }
      },
    );
  }

  // кнопка возврата на страницу входа в приложение
  Widget buildReturnButton(BuildContext context) {
    return BuildExitButtonWidget(
      buttonText: 'ВЕРНУТЬСЯ',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "sign_in");
      },
    );
  }
}
