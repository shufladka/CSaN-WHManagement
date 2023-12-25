import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// класс с декорацией полей ввода
class InputDecorationBuilder {
  static InputDecoration buildInputDecoration(BuildContext context, String hintText) {
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
}