
import 'package:csan/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../service/auth/firebase_auth_service.dart';

// класс для создания страницы для установления стандартной роли для всех новых пользователей
class SetDefaultRolePage extends StatefulWidget {
  const SetDefaultRolePage({super.key});

  @override
  _SetDefaultRolePageState createState() => _SetDefaultRolePageState();
}

class _SetDefaultRolePageState extends State<SetDefaultRolePage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode? roleFocusNode;
  TextEditingController? roleController;

  final unfocusNode = FocusNode();

  final FirebaseAuthService _auth = FirebaseAuthService();


  // обновление роли в таблице default_role и возврат на страницу панели администратора
  void _setDefaultRole() async {
    String role = roleController!.text;

    await _auth.setDefaultRole(role);

    Navigator.pushReplacementNamed(context, "admin_panel");
  }

  @override
  void initState() {
    super.initState();

    roleController ??= TextEditingController();
    roleFocusNode ??= FocusNode();

    unfocusNode.addListener(() {
      if (unfocusNode.hasFocus) {
        unfocusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    roleFocusNode?.dispose();
    roleController?.dispose();

    unfocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Настройка прав по умолчанию',
      color: Theme
          .of(context)
          .primaryColor
          .withAlpha(0XFF),
      child: GestureDetector(
        onTap: () =>
        unfocusNode.canRequestFocus
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

  Widget buildSignInContainer(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
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
        buildDefaultRoleField(context),
        buildSetDefaultRoleButton(context),
        buildAdminPanelPageButton(context),
        //getDisplayCurrentUserNameButton(context),
      ],
    );
  }

  Widget buildSignInForm(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
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
          'НАСТРОЙКА ПРАВ ПО УМОЛЧАНИЮ',
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

  Widget buildDefaultRoleField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
      child: TextFormField(
        controller: roleController,
        focusNode: roleFocusNode,
        textCapitalization: TextCapitalization.none,
        decoration: buildDefaultRoleFieldInputDecoration(context),
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.black45,
      ),
    );
  }

  InputDecoration buildDefaultRoleFieldInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: 'роль по умолчанию',
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

  Widget buildSetDefaultRoleButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'УСТАНОВИТЬ НОВУЮ РОЛЬ ПО УМОЛЧАНИЮ',
      onPressed: () {
        _setDefaultRole();
      },
    );
  }

  Widget buildAdminPanelPageButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ВЕРНУТЬСЯ В ПАНЕЛЬ АДМИНИСТРАТОРА',
      onPressed: () {
        Navigator.pushReplacementNamed(context, "admin_panel");
      },
    );
  }

  Widget getDisplayCurrentUserNameButton(BuildContext context) {
    return BuildButtonWidget(
      buttonText: 'ПРАВА ТЕКУЩЕГО ПОЛЬЗОВАТЕЛЯ',
      onPressed: () {
        //Navigator.pushReplacementNamed(context, "test");
        print(FirebaseAuth.instance.currentUser!.displayName);
      },
    );
  }
}