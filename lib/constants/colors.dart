import 'package:flutter/material.dart';

class TrakyaColors {
  static bool _isDark = false;

  // tema modunu ayarlamak için
  static void setDarkMode(bool isDark) {
    _isDark = isDark;
  }

  // getter'lar temaya göre renk döndürür
  static Color get background => _isDark ? const Color(0xFF121212) : const Color(0xFFf7f7f7);
  static Color get primary => _isDark ? const Color(0xFF513174) : const Color(0xFF513174);
  static Color get card => _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFEFEFEF);
  static Color get negative => _isDark ? Colors.white : const Color(0xFF050306);
}