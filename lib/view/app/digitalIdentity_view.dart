import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/constants/images.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';

class DigitalIdentityView extends ConsumerStatefulWidget {
  const DigitalIdentityView({super.key});

  @override
  ConsumerState<DigitalIdentityView> createState() =>
      _DigitalIdentityViewState();
}

class _DigitalIdentityViewState extends ConsumerState<DigitalIdentityView> {
  bool isChecked = false;
  bool isLoading = true; // başta yükleme göstermek için

  @override
  void initState() {
    super.initState();
    // 2 saniye sonra yükleme bitsin
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  // Helper widget
  Widget infoRow(String label, String value) {
    return paddedRow(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,

                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: "robotoBold",
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget paddedRow(Widget row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: row,
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(authProvider);

    if (student == null) {
      return const Scaffold(
        body: Center(child: Text("Öğrenci bilgisi bulunamadı")),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TrakyaColors.primary,
        toolbarHeight: 60,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical:10),
          child: Image.asset(TrakyaImages.logo),
        ),
        actionsPadding: const EdgeInsets.all(12),
        automaticallyImplyLeading: false,
        title: Text(
          "Trakya Kampüs 4.0",
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 1,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.logout, size: 30, color: Colors.white),
          ),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // açılışta progress göster
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Container(
                margin: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    paddedRow(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Öğrenci Kimlik Kartı",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  "Student Identity Card",
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: student.photo != null
                                  ? FileImage(File(student.photo!))
                                  : null,
                              child: student.photo == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    infoRow("Ad Soyad", student.fullName),
                    Divider(),
                    infoRow("T.C. Kimlik No", student.tcNo),
                    Divider(),
                    infoRow("Öğrenci No", student.studentNo),
                    Divider(),
                    infoRow("Okul", student.faculty),
                    Divider(),
                    infoRow("Program", student.program),
                    Divider(),
                    infoRow("Sınıf", student.classYear.toString()),
                    Divider(),
                    paddedRow(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Öğrencilik Hakkı Var",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "robotoBold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    infoRow("Kayıt Tarihi", student.registrationDate),
                    SizedBox(height: 15),
                    paddedRow(
                      Text(
                        "Dijital kimliği doğrulamak için okutunuz...",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    paddedRow(
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: QrImageView(
                            data:
                                '''
Ad Soyad: ${student.fullName}
Öğrenci No: ${student.studentNo}
Fakülte: ${student.faculty}
Program: ${student.program}
''',
                            version: QrVersions.auto,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
    );
  }
}
