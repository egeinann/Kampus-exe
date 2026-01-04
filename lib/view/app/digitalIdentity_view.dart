import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
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

  // Genel TextStyle
  final TextStyle labelStyle = TextStyle(
    fontSize: 15.sp,
    color: Colors.grey.shade600,
    fontWeight: FontWeight.bold,
    fontFamily: "robotoBold",
  );

  final TextStyle valueStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "robotoBold",
  );

  // Helper widget
  Widget infoRow(String label, String value) {
    return paddedRow(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }

  Widget paddedRow(Widget row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Image.asset(TrakyaImages.logo),
        ),
        actionsPadding: const EdgeInsets.all(12),
        automaticallyImplyLeading: false,
        title: Text(
          "Trakya Kampüs 4.0",
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.logout, size: 24.sp, color: Colors.white),
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
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    paddedRow(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text("Alternatif Bluetooth Arama"),
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    paddedRow(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Öğrenci Kimlik Kartı"),
                              Text(
                                "Student Identity Card",
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                          vertical: 6,
                          horizontal: 12,
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
                              size: 16.sp,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Öğrencilik Hakkı Var",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
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
                    SizedBox(height: 2.h),
                    paddedRow(
                      Text(
                        "Dijital kimliği doğrulamak için okutunuz...",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    paddedRow(
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
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
                  ],
                ),
              ),
            ),
    );
  }
}
