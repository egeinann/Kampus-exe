import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trakya_kampus_41/constants/colors.dart';

Widget customButton(
  String text,
  IconData icon,
  BuildContext context, {
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: TrakyaColors.primary,
      foregroundColor: Colors.white, // ikon ve yazı rengi
      splashFactory: NoSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // köşeleri yuvarla
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    ),
    onPressed: onPressed,
    child: Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 26,),
        Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white
          ),
        ),
      ],
    ),
  );
}
