import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakya_kampus_41/models/student_model.dart';

final authProvider = NotifierProvider<AuthNotifier, StudentModel?>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<StudentModel?> {
  static const _studentKey = 'student_data';

  @override
  StudentModel? build() {
    _loadFromLocal();
    return null;
  }

  String prefixFromYear(int year) {
    if (year < 2020) {
      throw ArgumentError('2020 öncesi kayıt yılı desteklenmiyor');
    }

    final int offset = year - 2020;

    if (offset == 0) return '1200';

    final int lastTwo = offset * 10 + 1;
    return '12${lastTwo.toString().padLeft(2, '0')}';
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_studentKey);

    if (jsonString != null) {
      state = StudentModel.fromJsonString(jsonString);
    }
  }

  String generateStudentNo(int registrationYear) {
    final prefix = prefixFromYear(registrationYear);

    final random = Random();
    final randomStr = random.nextInt(999999).toString().padLeft(6, '0');

    return '$prefix$randomStr';
  }

  Future<void> registerStudent({
    String? photo,
    required String fullName,
    required String tcNo,
    required String faculty,
    required String program,
    required int classYear,
    required int registrationYear,
    required String registrationDate,
    required String studentNo,
  }) async {
    final student = StudentModel(
      photo: photo,
      fullName: fullName,
      tcNo: tcNo,
      studentNo: studentNo,
      faculty: faculty,
      program: program,
      classYear: classYear,
      registrationDate: registrationDate,
    );

    state = student;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, student.toJsonString());
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_studentKey);
    state = null;
  }

  Future<void> updateStudent({
    String? photo,
    required String fullName,
    required String tcNo,
    required String faculty,
    required String program,
    required int classYear,
    required String registrationDate,
    required String studentNo,
  }) async {
    if (state == null) return;

    final editablePart = studentNo.substring(studentNo.length - 6);

    // Önek: kayıt yılına göre profil ekranında güncellenmiş olabilir (ilk 4 hane)
    final String prefix = studentNo.length >= 10
        ? studentNo.substring(0, 4)
        : state!.studentNo.substring(0, 4);

    final finalStudentNo = '$prefix$editablePart';

    final updatedStudent = state!.copyWith(
      photo: photo,
      fullName: fullName,
      tcNo: tcNo,
      studentNo: finalStudentNo,
      faculty: faculty,
      program: program,
      classYear: classYear,
      registrationDate: registrationDate,
    );

    state = updatedStudent;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, updatedStudent.toJsonString());
  }
}
