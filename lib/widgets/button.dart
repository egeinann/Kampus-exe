import 'package:flutter/material.dart';
import 'package:trakya_kampus_41/constants/colors.dart';

Widget customButton(
  String text,
  IconData icon,
  BuildContext context,
  {required VoidCallback onPressed}
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: TrakyaColors.primary,
      foregroundColor: Colors.white, // ikon ve yazı rengi
      splashFactory: NoSplash.splashFactory,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // köşeleri yuvarla
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    ),
    onPressed: onPressed,
    child: Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
