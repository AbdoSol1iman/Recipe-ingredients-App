import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasftk/presentation/screens/bmi/bmi_page.dart';
import 'package:wasftk/presentation/screens/bmi/constants.dart';
class BmiAppScreen extends StatelessWidget {
  const BmiAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.w600),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500),
          bodySmall: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500),
          labelSmall: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white54,
              fontWeight: FontWeight.w500),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: kblueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: kblueColor),
        iconTheme: const IconThemeData(size: 90, color: Colors.white),
        useMaterial3: true,
      ),
      child: const BmiPage(),
    );
  }
}