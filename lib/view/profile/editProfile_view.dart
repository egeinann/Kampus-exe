import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

  String fixedStudentNoPrefix = '';

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController tcController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController studentNoController = TextEditingController();

  String? selectedFaculty;
  String? selectedProgram;
  int? selectedClass;

  @override
  void initState() {
    super.initState();

    final student = ref.read(authProvider);
    if (student == null) return;

    fullNameController.text = student.fullName;
    tcController.text = student.tcNo;
    dateController.text = student.registrationDate;

    // 🔑 TEK KAYNAK: modelde kayıtlı öğrenci numarası
    fixedStudentNoPrefix = student.studentNo.substring(0, 4);
    studentNoController.text = student.studentNo;
    studentNoController.addListener(_protectStudentNoPrefix);

    selectedFaculty = student.faculty;
    selectedProgram = student.program;
    selectedClass = student.classYear;

    if (student.photo != null) {
      _imageFile = File(student.photo!);
    }
  }

  void _protectStudentNoPrefix() {
    final text = studentNoController.text;

    // Prefix bozulduysa düzelt

    if (!text.startsWith(fixedStudentNoPrefix)) {
      String editablePart = '';

      if (text.length >= fixedStudentNoPrefix.length + 1) {
        editablePart = text.substring(fixedStudentNoPrefix.length);
      }

      final newText = '$fixedStudentNoPrefix$editablePart';

      studentNoController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      return;
    }

    // Cursor prefix'in önüne geçemesin
    if (studentNoController.selection.start < fixedStudentNoPrefix.length) {
      studentNoController.selection = TextSelection.collapsed(
        offset: fixedStudentNoPrefix.length,
      );
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
            fontSize: 18,
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
    if (selectedFaculty == null ||
        selectedProgram == null ||
        selectedClass == null) {
      _showAutoCloseDialog("Tüm alanları doldurmalısınız");
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

    return Scaffold(
      appBar: trakyaAppBar(context, "Düzenle", [
        GestureDetector(
          onTap: ()=>Navigator.pop(context),
          child: Icon(Icons.close,color: Colors.white,size: 30,)),
      ], backgroundColor: Colors.black),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 20,
              children: [
                GestureDetector(
                  onTap: _showPickerSheet,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
                        ? Icon(Icons.person, size: 24)
                        : null,
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

  TrakyaTextfield idField() => TrakyaTextfield(
    context: context,
    prefixIcon: const Icon(Icons.add_card),
    hintText: "TC Kimlik",
    maxLength: 11,
    textEditingController: tcController,
  );

  TrakyaTextfield studentNoField() => TrakyaTextfield(
    context: context,
    prefixIcon: const Icon(Icons.confirmation_number),
    hintText: "Öğrenci No",
    maxLength: 10,
    textEditingController: studentNoController,
  );

  DropdownButtonFormField<String> facultyDropdown() {
    return DropdownButtonFormField<String>(
      borderRadius: BorderRadius.circular(16),
      isExpanded: true,
      initialValue: selectedFaculty,
      decoration: _dropdownDecoration(
        icon: Icons.business_outlined,
        hint: "Fakülte",
      ),
      items: facultyPrograms.keys
          .map<DropdownMenuItem<String>>(
            (faculty) => DropdownMenuItem<String>(
              value: faculty,
              child: Text(
                faculty,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TrakyaColors.negative,
                  fontFamily: "RobotoBold",
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val == selectedFaculty) return;
        setState(() {
          selectedFaculty = val;
          selectedProgram = null;
        });
      },
    );
  }

  DropdownButtonFormField<String> programDropdown() {
    final List<String> programs =
        facultyPrograms[selectedFaculty] ?? <String>[];
    final bool isValidSelectedProgram = programs.contains(selectedProgram);
    return DropdownButtonFormField<String>(
      isExpanded: true,
      menuMaxHeight: 200,
      borderRadius: BorderRadius.circular(16),
      initialValue: isValidSelectedProgram ? selectedProgram : null,
      decoration: _dropdownDecoration(
        icon: Icons.school_outlined,
        hint: "Program",
      ),
      items: programs
          .map<DropdownMenuItem<String>>(
            (program) => DropdownMenuItem<String>(
              value: program,
              child: Text(
                program,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TrakyaColors.negative,
                  fontFamily: "RobotoBold",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
          .toList(),
      onChanged: programs.isEmpty
          ? null
          : (val) {
              setState(() {
                selectedProgram = val;
              });
            },
    );
  }

  DropdownButtonFormField<int> classField() {
    return DropdownButtonFormField<int>(
      value: selectedClass,
      decoration: _dropdownDecoration(icon: Icons.numbers, hint: "Sınıf"),
      items: [1, 2, 3, 4]
          .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
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
        dateController.text = "${picked.day}.${picked.month}.${picked.year}";
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
