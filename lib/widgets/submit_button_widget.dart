import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const BuildButtonWidget ({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            elevation: 3,
            shape: RoundedRectangleBorder(

              // устанавливаем радиус закругления бортов кнопки
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            buttonText,
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
}

class BuildExitButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const BuildExitButtonWidget ({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            elevation: 3,
            shape: RoundedRectangleBorder(

              // устанавливаем радиус закругления бортов кнопки
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            buttonText,
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
}
