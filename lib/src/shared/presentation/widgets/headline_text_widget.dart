import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Headline to display category or cashflow names at the top of the Screen
class HeadlineTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const HeadlineTextWidget({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
