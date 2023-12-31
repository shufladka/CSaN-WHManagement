import 'package:csan/service/auth/firebase_auth_service.dart';
import 'package:csan/service/auth/form_validation_service.dart';
import 'package:csan/widgets/input_decoration_widget.dart';
import 'package:csan/widgets/submit_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // переменная для скрытия клавиатуры нажатием по пустому полю
  final unfocusNode = FocusNode();

  FocusNode? emailFocusNode;
  TextEditingController? emailController;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  bool passwordVisibility = false; // Инициализируем поле passwordVisibility

  // инициализация полей сброса ошибок при невалидном вводе
  String? emailError;
  String? passwordError;

  // определяем текущее значение чекбокса
  bool? checkboxValue;

  // значение чекбокса по умолчанию
  bool checkBoxDefaultState = false;

  // сервис аутентификации пользователя
  final FirebaseAuthService _auth = FirebaseAuthService();

  // обработка перехода через вызов сервиса аутентификации
  void _signIn() async {

    String email = emailController!.text;
    String password = passwordController!.text;

    User? user = await _auth.signInEmailPassword(context, email, password);

    if (user != null) {
      print('user successfully signed in.');
      _saveData(); // Добавлен вызов _saveData
      Navigator.pushReplacementNamed(context, "lobby");
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

    passwordVisibility = false;

    // загрузка сохраненных данных при запуске страницы
    _loadSavedData();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();

    super.dispose();
  }

  // метод для автозагрузки сохраненных данных
  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // получения состояния чекбокса
    setState(() {

      // получение состояния чекбокса
      checkboxValue = prefs.getBool('rememberMe') ?? checkBoxDefaultState;

      // если чекбокс прожат, подгружаем поля почтового адреса и пароля в соответствующие поля
      if (checkboxValue!) {
        emailController!.text = prefs.getString('savedEmail') ?? '';
        passwordController!.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  // метод для сохранения введенных данных
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', checkboxValue!);

    // если чекбокс прожат, сохраняем поля почтового адреса и пароля
    if (checkboxValue!) {
      prefs.setString('savedEmail', emailController!.text);
      prefs.setString('savedPassword', passwordController!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Вход',
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
              child: buildSignInForm(context),
            ),
          ),
        ),
      ),
    );
  }

  // контейнер страницы входа в приложение
  Widget buildSignInContainer(BuildContext context) {
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

  // форма полей страницы входа в приложение
  Widget buildFormFields(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(context),
        buildEmailField(context),
        buildPasswordField(context),
        buildRememberMeCheckbox(context),
        buildSignInButton(context),
        buildRegistrationLink(context),
        buildForgotPasswordButton(context),
      ],
    );
  }

  // построение формы страницы входа в приложение
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
          color: Colors.white,
        ),
        child: Align(
          alignment: const AlignmentDirectional(0.00, 0.00),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32, 10, 32, 32),
            child: buildSignInContainer(context),
          ),
        ),
      ),
    );
  }

  // виджет заголовка страницы входа в приложение
  Widget buildTitle(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
        child: Text(
          'ВХОД В АККАУНТ',
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

  // форма поля ввода почтового адреса
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

  // форма ввода пароля
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

  // декоратор поля ввода пароля
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

  // виджет с чекбоксом для запоминания последних введенных данных пользователя
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
            value: checkboxValue ??= checkBoxDefaultState,
            onChanged: (newValue) async {
              setState(() => checkboxValue = newValue!);
              _saveData(); // сохранение данных при изменении чекбокса
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

  // виджет кнопки отправки формы для входа в приложение
  Widget buildSignInButton(BuildContext context) {

    // экземпляр класса валидации формы регистрации нового пользователя
    CustomFormValidator formValidator = CustomFormValidator(
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: null,
      needPassword: false,
      needConfirmPassword: false,
    );

    return BuildButtonWidget(
      buttonText: 'ВОЙТИ',
      onPressed: () {

        // если форма валидна, переходим к странице входа в аккаунт
        if (formValidator.validateForm(context)) {
          _signIn();
        }
      },
    );
  }

  // виджет кнопки с переходом на страницу регистрации
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

  // виджет кнопки с переходом на страницу восстановления пароля
  Widget buildForgotPasswordButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 16),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('pass_reset');
            },
            child: Container(
              color: Colors.white, // белый фон
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
