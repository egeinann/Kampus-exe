import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/data/faculty_programs.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/view/auth/login_view.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';
import 'package:trakya_kampus_41/widgets/textfield.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  String? generatedStudentNo;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController tcController = TextEditingController();
  String? selectedFaculty;
  String? selectedProgram;

  final TextEditingController dateController = TextEditingController();
  int? selectedClass;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint('Fotoğraf seçme hatası: $e');
    }
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
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  bool _validateForm() {
    if (_imageFile == null) {
      _showAutoCloseDialog("Lütfen profil fotoğrafı ekleyin");
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
      _showAutoCloseDialog("Kayıt tarihi seçmelisiniz");
      return false;
    }

    return true; // her şey tamam
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

  void _showConfirmSheet(AuthNotifier auth) {
    // Kayıt yılı, text field boşsa mevcut yıl
    int registrationYear =
        int.tryParse(dateController.text.split('.').last) ??
        DateTime.now().year;

    generatedStudentNo ??= auth.generateStudentNo(registrationYear);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "SON KONTROL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            _buildInfoRow("Ad Soyad", fullNameController.text),
            _buildInfoRow("TC", tcController.text),
            _buildInfoRow("Fakülte", selectedFaculty!),
            _buildInfoRow("Program", selectedProgram!),
            _buildInfoRow("Sınıf", selectedClass?.toString() ?? ""),
            _buildInfoRow("Kayıt Tarihi", dateController.text),
            _buildInfoRow("Öğrenci No", generatedStudentNo!),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TrakyaColors.negative,
                foregroundColor: Colors.white,
                splashFactory: NoSplash.splashFactory,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
              ),
              onPressed: () {
                auth.registerStudent(
                  photo: _imageFile?.path,
                  fullName: fullNameController.text,
                  tcNo: tcController.text,
                  faculty: selectedFaculty!,
                  program: selectedProgram!,
                  classYear: selectedClass ?? 1,
                  registrationYear: registrationYear,
                  studentNo: generatedStudentNo!,
                  registrationDate: dateController.text,
                );

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginView()),
                );
              },
              child: Text(
                "Kaydı oluştur",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: TrakyaColors.background,
                  fontFamily: "RobotoBold",
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: TrakyaColors.negative,
              borderRadius: BorderRadius.circular(4),
            ),
            width: 6,
            height: 16,
          ),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: TrakyaColors.negative,
              fontFamily: "RobotoBold",
            ),
          ),

          Spacer(),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: TrakyaColors.negative,
                  fontFamily: "RobotoBold",
                ),

                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
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
          "Trakya Kampüs 4.1",
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
                Text(
                  "KAYIT OL",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: TrakyaColors.negative,
                    fontFamily: "RobotoBold",
                  ),
                ),
                Divider(),

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
                            ? Icon(
                                Icons.person_3_rounded,
                                color: Colors.white,
                                size: 22.sp,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TrakyaColors.primary,
                          ),
                          child: Icon(
                            _imageFile == null
                                ? Icons.add
                                : Icons.change_circle,
                            color: TrakyaColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                fullNameField(),
                idField(),
                facultyDropdown(),
                programDropdown(),
                classField(),
                dateField(),
                registerButton(auth),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TrakyaTextfield fullNameField() {
    return TrakyaTextfield(
      context: context,
      prefixIcon: const Icon(Icons.person),
      hintText: "Ad Soyad",
      isUppercase: true,
      exampleText: "EGE INAN (boşluk bırak)",
      textEditingController: fullNameController,
    );
  }

  TrakyaTextfield idField() {
    return TrakyaTextfield(
      context: context,
      prefixIcon: const Icon(Icons.add_card),
      hintText: "TC Kimlik",
      maxLength: 11,
      textEditingController: tcController,
    );
  }

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
                  fontSize: 16.sp,
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
                  fontSize: 16.sp,
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
      isExpanded: true,
      initialValue: selectedClass,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.numbers),
        hintText: "Sınıf",
        hintStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: TrakyaColors.negative,
        ),
        filled: true,
        fillColor: TrakyaColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      ),
      items: [1, 2, 3, 4]
          .map(
            (num) => DropdownMenuItem(
              value: num,
              child: Text(
                num.toString(),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: TrakyaColors.negative,
                  fontFamily: "RobotoBold",
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() {
          selectedClass = val;
        });
      },
    );
  }

  TextField dateField() {
    return TextField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1990),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );
        if (pickedDate != null) {
          dateController.text =
              "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}";
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: TrakyaColors.card,
        prefixIcon: const Icon(Icons.calendar_month),
        hintText: "Kayıt Tarihi",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        hintStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          fontFamily: "Roboto",
          color: TrakyaColors.negative,
        ),
      ),
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w900,
        color: TrakyaColors.negative,
      ),
    );
  }

  ElevatedButton registerButton(AuthNotifier auth) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: TrakyaColors.negative,
        foregroundColor: Colors.white,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      onPressed: () {
        if (!_validateForm()) return;

        _showConfirmSheet(auth);
      },
      child: const Text(
        "Kayıt ol",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
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
      contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      hintStyle: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: TrakyaColors.negative,
      ),
    );
  }
}
