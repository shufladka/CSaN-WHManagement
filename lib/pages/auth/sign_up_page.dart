import 'package:csan/service/auth/form_validator.dart';
import 'package:csan/widgets/input_decoration_widget.dart';
import 'package:csan/widgets/submit_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:csan/service/auth/firebase_auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>(); // Ключ формы

  final unfocusNode = FocusNode();

  FocusNode? emailFocusNode;
  TextEditingController? emailController;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  bool passwordVisibility = false; // Инициализируем поле passwordVisibility

  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordController;
  bool confirmPasswordVisibility = false; // Инициализируем поле confirmPasswordVisibility

  // значение чекбокса по умолчанию
  bool checkBoxDefaultState = false;

  bool isButtonPressed = false;

  // сервис аутентификации пользователя
  final FirebaseAuthService _auth = FirebaseAuthService();

  // обработка перехода через вызов сервиса аутентификации
  void _signUp() async {

    String email = emailController!.text;
    String password = passwordController!.text;

    User? user = await _auth.signUpEmailPassword(context, email, password);

    if (user != null) {
      print('user is successfully created.');
      Navigator.pushReplacementNamed(context, "sign_in");
    } else {
      print('some happend :(');
    }
  }

  @override
  void initState() {
    super.initState();

    emailController ??= TextEditingController();
    emailFocusNode ??= FocusNode();

    passwordController ??= TextEditingController();
    passwordFocusNode ??= FocusNode();

    confirmPasswordController ??= TextEditingController();
    confirmPasswordFocusNode ??= FocusNode();

    // настройка видимости полей пароля и подтверждения пароля по умолчанию
    passwordVisibility = false;
    confirmPasswordVisibility = false;

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();

    confirmPasswordFocusNode?.dispose();
    confirmPasswordController?.dispose();
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'sign_up',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: GestureDetector(
        onTap: () => unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: Form( // Используем форму
            key: _formKey, // Устанавливаем ключ формы
            child: Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: SingleChildScrollView(
                child: buildSignUpForm(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignUpContainer(BuildContext context) {
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
        buildEmailField(context),
        buildPasswordField(context),
        buildConfirmPasswordField(context),
        buildCreateAccountButton(context),
        buildSignInLink(context),
      ],
    );
  }

  Widget buildSignUpForm(BuildContext context) {
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
            child: buildSignUpContainer(context),
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
          'РЕГИСТРАЦИЯ АККАУНТА',
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

  Widget buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: passwordController,
        focusNode: passwordFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: !passwordVisibility,
        decoration: buildPasswordInputDecoration(context),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black45,
      ),
    );
  }

  Widget buildConfirmPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: confirmPasswordController,
        focusNode: confirmPasswordFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: !confirmPasswordVisibility,
        decoration: buildConfirmPasswordInputDecoration(context),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black45,
      ),
    );
  }

  InputDecoration buildPasswordInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'пароль',
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
      suffixIcon: InkWell(
        onTap: () => setState(() => passwordVisibility = !passwordVisibility),
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          passwordVisibility
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  InputDecoration buildConfirmPasswordInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'подтвердите пароль',
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
      suffixIcon: InkWell(
        onTap: () => setState(() => confirmPasswordVisibility = !confirmPasswordVisibility),
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          confirmPasswordVisibility
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  // кнопка для отправки формы для создания нового аккаунта
  Widget buildCreateAccountButton(BuildContext context) {

    // экземпляр класса валидации формы регистрации нового пользователя
    CustomFormValidator formValidator = CustomFormValidator(
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      needPassword: true,
      needConfirmPassword: true,
    );

    return BuildButtonWidget(
      buttonText: 'СОЗДАТЬ АККАУНТ',
      onPressed: () {

        // если форма валидна, переходим к странице входа в аккаунт
        if (formValidator.validateForm(context)) {
          _signUp();
        }
      },
    );
  }

  // кнопка для перехода к странице для входа в аккаунт
  Widget buildSignInLink(BuildContext context) {
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
                'у вас есть аккаунт?',
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
                  Navigator.of(context).pushNamed('sign_in');
                },
                child: Text(
                  'вход',
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
}
