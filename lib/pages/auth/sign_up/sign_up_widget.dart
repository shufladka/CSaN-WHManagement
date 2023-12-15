//import 'dart:io';

import 'package:csan/widgets/submit_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:csan/service/auth/firebase_auth_service.dart';

import 'sign_up_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late SignUpModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>(); // Ключ формы

  // значение чекбокса по умолчанию
  bool checkBoxDefaultState = false;

  bool isButtonPressed = false;

  final FirebaseAuthService _auth = FirebaseAuthService();

  void _signUp() async {

    String email = _model.emailController!.text;
    //String? username = _model.usernameController?.text;
    String password = _model.passwordController!.text;

    User? user = await _auth.signUpEmailPassword(context, email, password);

    if (user != null) {
      print('user is successfully created.');
      Navigator.pushNamed(context, "sign_in");
    } else {
      print('some happend :(');
    }

  }

  @override
  void initState() {
    super.initState();
    _model = SignUpModel();

    _model.emailController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.usernameController ??= TextEditingController();
    _model.usernameFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    _model.confirmPasswordController ??= TextEditingController();
    _model.confirmPasswordFocusNode ??= FocusNode();

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
      title: 'sign_up',
      color: Theme.of(context).primaryColor.withAlpha(0XFF),
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
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
        //buildNicknameField(context),
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
            //child: buildFormFields(context),
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
        controller: _model.emailController,
        focusNode: _model.emailFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: buildInputDecoration(context, 'почтовый адрес'),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Theme.of(context).primaryColor,
        onChanged: (value) => _model.validate(value, 'email'),
        validator: (_) => _model.emailError, // Возвращаем ошибку из модели
      ),
    );
  }

  Widget buildNicknameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: _model.usernameController,
        focusNode: _model.usernameFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        decoration: buildInputDecoration(context, 'псевдоним'),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        keyboardType: TextInputType.name,
        cursorColor: Theme.of(context).primaryColor,
        onChanged: (value) => _model.validate(value, 'username'),
        validator: (_) => _model.usernameError, // Возвращаем ошибку из модели
        // validator: (value) => _model.validate(value, 'username'),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: _model.passwordController,
        focusNode: _model.passwordFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: !_model.passwordVisibility,
        decoration: buildPasswordInputDecoration(context),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black45,
        onChanged: (value) => _model.validate(value, 'password'),
        validator: (_) => _model.passwordError, // Возвращаем ошибку из модели
        //validator: (value) => _model.validate(value, 'password'), // Обновленный валидатор
      ),
    );
  }

  Widget buildConfirmPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: _model.confirmPasswordController,
        focusNode: _model.confirmPasswordFocusNode,
        textCapitalization: TextCapitalization.none,
        obscureText: !_model.confirmPasswordVisibility,
        decoration: buildConfirmPasswordInputDecoration(context),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black45,
        onChanged: (value) => _model.validate(value, 'confirmPassword'),
        validator: (_) => _model.confirmPasswordError, // Возвращаем ошибку из модели
        //validator: (value) => _model.validate(value, 'confirmPassword'), // валидатор, который маппится на поля ввода и подтверждения пароля
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
        onTap: () => setState(() => _model.passwordVisibility = !_model.passwordVisibility),
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          _model.passwordVisibility
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
        onTap: () => setState(() => _model.confirmPasswordVisibility = !_model.confirmPasswordVisibility),
        focusNode: FocusNode(skipTraversal: true),
        child: Icon(
          _model.confirmPasswordVisibility
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  /*
  // кнопка для добавления пользовательских данных в базу
  Widget buildCreateAccountButton(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isButtonPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isButtonPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isButtonPressed = false;
        });
      },
      onTap: () {
        // Действия при нажатии на кнопку
        validateForm(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Действия при нажатии на кнопку
              validateForm(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonPressed ? Colors.grey : Colors.black87,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              'СОЗДАТЬ АККАУНТ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
  */

  Widget buildCreateAccountButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'СОЗДАТЬ АККАУНТ',
      onPressed: () {
        // Вызываем метод для валидации формы регистрации
        validateForm(context);
      },
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
    if (_model.emailController!.text.length < 10) {
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

    /*
    // Проверяем, совпадают ли пароль и подтверждение пароля
    if (_model.usernameController!.text.length < 4) {
      // Если не совпадают, выведем ошибку (можно использовать SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Длина псевдонима должна составлять не менее 4 символов.',
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
          backgroundColor: Colors.red,
        ),
      );
      // Прекращаем выполнение метода
      return;
    }
     */

    // Проверяем, совпадают ли пароль и подтверждение пароля
    if (_model.passwordController!.text.length < 6) {
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

    // Проверяем, совпадают ли пароль и подтверждение пароля
    if (_model.confirmPasswordController!.text.length < 6) {
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

    // Проверяем, совпадают ли пароль и подтверждение пароля
    if (_model.passwordController?.text != _model.confirmPasswordController?.text) {
      // Если не совпадают, выведем ошибку (можно использовать SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Пароли не совпадают.',
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
          backgroundColor: Colors.red,
        ),
      );
      // Прекращаем выполнение метода
      return;
    }

    //  код для обработки создания аккаунта
    print('Button pressed ...');

    _signUp();
  }

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
