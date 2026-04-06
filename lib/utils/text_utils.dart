import 'package:flutter/material.dart';

String toTurkishUpperCase(String text) {
  const turkishLower = 'abcçdefgğhıijklmnoöprsştuüvyz';
  const turkishUpper = 'ABCÇDEFGĞHIİJKLMNOÖPRSŞTUÜVYZ';

  final buffer = StringBuffer();
  for (var char in text.characters) {
    final index = turkishLower.indexOf(char);
    if (index != -1) {
      buffer.write(turkishUpper[index]);
    } else {
      buffer.write(char.toUpperCase());
    }
  }
  return buffer.toString();
}