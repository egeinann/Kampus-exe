import 'dart:convert';

class StudentModel {
  final String? photo;
  final String fullName;
  final String tcNo;
  final String studentNo;
  final String faculty;
  final String program;
  final int classYear;
  final String registrationDate;

  StudentModel({
    this.photo,
    required this.fullName,
    required this.tcNo,
    required this.studentNo,
    required this.faculty,
    required this.program,
    required this.classYear,
    required this.registrationDate,
  });

  /// JSON -> Model
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      photo: json['photo'],
      fullName: json['fullName'],
      tcNo: json['tcNo'],
      studentNo: json['studentNo'],
      faculty: json['faculty'],
      program: json['program'],
      classYear: json['classYear'],
      registrationDate: json['registrationDate'],
    );
  }

  /// Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'fullName': fullName,
      'tcNo': tcNo,
      'studentNo': studentNo,
      'faculty': faculty,
      'program': program,
      'classYear': classYear,
      'registrationDate': registrationDate,
    };
  }

  /// UPDATE için altın anahtar
  StudentModel copyWith({
    String? photo,
    String? fullName,
    String? tcNo,
    String? studentNo,
    String? faculty,
    String? program,
    int? classYear,
    String? registrationDate,
  }) {
    return StudentModel(
      photo: photo ?? this.photo,
      fullName: fullName ?? this.fullName,
      tcNo: tcNo ?? this.tcNo,
      studentNo: studentNo ?? this.studentNo,
      faculty: faculty ?? this.faculty,
      program: program ?? this.program,
      classYear: classYear ?? this.classYear,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }

  /// SharedPreferences için direkt String
  String toJsonString() => jsonEncode(toJson());

  /// SharedPreferences'ten direkt oku
  factory StudentModel.fromJsonString(String source) =>
      StudentModel.fromJson(jsonDecode(source));
}
