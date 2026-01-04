import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/data/faculty_programs.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';
import 'package:trakya_kampus_41/widgets/button.dart';
import 'package:trakya_kampus_41/widgets/textfield.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  File? _imageFile;
  String fixedStudentNoPrefix = '';
  final ImagePicker _picker = ImagePicker();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController tcController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController studentNoController = TextEditingController();
  String? selectedFaculty;
  String? selectedProgram;
  int? selectedClass;
  String _prefixFromYear(int year) {
    if (year == 2020) return '1200';
    return '12${(year - 2020) + 1}1';
  }

  @override
  void initState() {
    super.initState();

    final student = ref.read(authProvider);

    if (student != null) {
      fullNameController.text = student.fullName;
      tcController.text = student.tcNo;
      dateController.text = student.registrationDate;

      if (student.registrationDate.isNotEmpty) {
        final year = int.parse(student.registrationDate.split('.').last);
        fixedStudentNoPrefix = _prefixFromYear(year);
      }
      studentNoController.text =
          '$fixedStudentNoPrefix${student.studentNo.substring(4)}';

      studentNoController.addListener(_protectStudentNoPrefix);

      selectedFaculty = student.faculty;
      selectedProgram = student.program;
      selectedClass = student.classYear;

      if (student.photo != null) {
        _imageFile = File(student.photo!);
      }
    }
  }

  void _protectStudentNoPrefix() {
    final text = studentNoController.text;

    // İlk 4 hane değiştirilmeye çalışıldıysa geri al
    if (!text.startsWith(fixedStudentNoPrefix)) {
      final editablePart = text.length >= 6
          ? text.substring(text.length - 6)
          : '';

      final newText = '$fixedStudentNoPrefix$editablePart';

      studentNoController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      return;
    }

    // Cursor ilk 4 hanenin önüne geçemesin
    if (studentNoController.selection.start < 4) {
      studentNoController.selection = const TextSelection.collapsed(offset: 4);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Fotoğraf Çek'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoCloseDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.redAccent,
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  bool _validateForm() {
    if (_imageFile == null) {
      _showAutoCloseDialog("Profil fotoğrafı boş olamaz");
      return false;
    }
    if (fullNameController.text.trim().isEmpty) {
      _showAutoCloseDialog("Ad Soyad boş bırakılamaz");
      return false;
    }
    if (tcController.text.trim().length != 11) {
      _showAutoCloseDialog("TC Kimlik 11 haneli olmalı");
      return false;
    }
    if (studentNoController.text.trim().length != 10) {
      _showAutoCloseDialog("Öğrenci No 10 haneli olmalı");
      return false;
    }
    if (selectedFaculty == null) {
      _showAutoCloseDialog("Fakülte seçmelisiniz");
      return false;
    }
    if (selectedProgram == null) {
      _showAutoCloseDialog("Program seçmelisiniz");
      return false;
    }
    if (selectedClass == null) {
      _showAutoCloseDialog("Sınıf seçmelisiniz");
      return false;
    }
    if (dateController.text.trim().isEmpty) {
      _showAutoCloseDialog("Kayıt tarihi boş olamaz");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: trakyaAppBar(
          context,
          "Düzenle",
          [],
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 20,
              children: [
                GestureDetector(
                  onTap: _showPickerSheet,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : null,
                        child: _imageFile == null
                            ? Icon(Icons.person, size: 22.sp)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: TrakyaColors.card,
                          child: const Icon(Icons.edit, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                fullNameField(),
                idField(),
                studentNoField(),
                facultyDropdown(),
                programDropdown(),
                classField(),
                dateField(),
                updateButton(auth),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TrakyaTextfield fullNameField() => TrakyaTextfield(
    context: context,
    prefixIcon: const Icon(Icons.person),
    hintText: "Ad Soyad",
    isUppercase: true,
    textEditingController: fullNameController,
  );

  TrakyaTextfield studentNoField() => TrakyaTextfield(
    context: context,
    prefixIcon: const Icon(Icons.confirmation_number),
    hintText: "Öğrenci No",
    maxLength: 10,
    textEditingController: studentNoController,
  );
  TrakyaTextfield idField() => TrakyaTextfield(
    context: context,
    prefixIcon: const Icon(Icons.add_card),
    hintText: "TC Kimlik",
    maxLength: 11,
    textEditingController: tcController,
  );

  DropdownButtonFormField<String> facultyDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedFaculty,
      decoration: _dropdownDecoration(icon: Icons.business, hint: "Fakülte"),
      items: facultyPrograms.keys
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(fontSize: 16.sp)),
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          selectedFaculty = val;
          selectedProgram = null;
        });
      },
    );
  }

  DropdownButtonFormField<String> programDropdown() {
    final programs = facultyPrograms[selectedFaculty] ?? [];
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: programs.contains(selectedProgram) ? selectedProgram : null,
      decoration: _dropdownDecoration(icon: Icons.school, hint: "Program"),
      items: programs
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(fontSize: 16.sp)),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => selectedProgram = val),
    );
  }

  DropdownButtonFormField<int> classField() {
    return DropdownButtonFormField<int>(
      value: selectedClass,
      decoration: _dropdownDecoration(icon: Icons.numbers, hint: "Sınıf"),
      items: [1, 2, 3, 4]
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.toString(), style: TextStyle(fontSize: 17.sp)),
            ),
          )
          .toList(),
      onChanged: (val) => setState(() => selectedClass = val),
    );
  }

  TextField dateField() => TextField(
    controller: dateController,
    readOnly: true,
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1990),
        lastDate: DateTime(2100),
        initialDate: DateTime.now(),
      );
      if (picked != null) {
        // Tarihi yaz
        dateController.text = "${picked.day}.${picked.month}.${picked.year}";

        final int year = picked.year;

        final int yearDiff = year - 2020;
        final String fixedPrefix = year == 2020 ? '1200' : '12${yearDiff + 1}1';

        fixedStudentNoPrefix = fixedPrefix;

        final oldNo = studentNoController.text;
        final String editablePart = oldNo.length >= 6
            ? oldNo.substring(oldNo.length - 6)
            : '000000';

        studentNoController.text = '$fixedPrefix$editablePart';

        studentNoController.selection = TextSelection.fromPosition(
          TextPosition(offset: studentNoController.text.length),
        );
      }
    },
    decoration: _dropdownDecoration(
      icon: Icons.calendar_month,
      hint: "Kayıt Tarihi",
    ),
  );

  Widget updateButton(AuthNotifier auth) {
    return customButton(
      "Güncelle",
      Icons.edit,
      context,
      onPressed: () {
        if (!_validateForm()) return;

        auth.updateStudent(
          photo: _imageFile?.path,
          fullName: fullNameController.text,
          tcNo: tcController.text,
          studentNo: studentNoController.text,
          faculty: selectedFaculty!,
          program: selectedProgram!,
          classYear: selectedClass!,
          registrationDate: dateController.text,
        );

        Navigator.pop(context);
      },
    );
  }

  InputDecoration _dropdownDecoration({
    required IconData icon,
    required String hint,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      filled: true,
      fillColor: TrakyaColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
