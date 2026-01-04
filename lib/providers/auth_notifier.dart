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

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_studentKey);

    if (jsonString != null) {
      state = StudentModel.fromJsonString(jsonString);
    }
  }

  String generateStudentNo(int registrationYear) {
    int yearCode =
        (registrationYear - 2020) * 10 + (registrationYear == 2020 ? 0 : 1);
    final random = Random();
    int randomNumber = random.nextInt(999999);
    String randomStr = randomNumber.toString().padLeft(6, '0');

    return '12${yearCode.toString().padLeft(2, '0')}$randomStr';
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

    // 🔑 Prefix her zaman kayıt tarihinden gelir
    final prefix = _prefixFromDate(registrationDate);

    // ✏️ Kullanıcı sadece son 6 haneyi etkiler
    final editablePart = studentNo.substring(studentNo.length - 6);

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

  String _prefixFromDate(String registrationDate) {
    final year = int.parse(registrationDate.split('.').last);
    if (year == 2020) return '1200';
    return '12${(year - 2020) + 1}1';
  }
}
