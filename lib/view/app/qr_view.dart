import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';

class QrView extends ConsumerStatefulWidget {
  const QrView({super.key});

  @override
  ConsumerState<QrView> createState() => _QrViewState();
}

class _QrViewState extends ConsumerState<QrView> {
  int _remainingTime = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
        if (mounted) Navigator.pop(context);
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _qrPayload(String fullName, String studentNo, String faculty, String program) {
    return '''
Ad Soyad: $fullName
Öğrenci No: $studentNo
Fakülte: $faculty
Program: $program
''';
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(authProvider);

    if (student == null) {
      return Scaffold(
        appBar: trakyaAppBar(context, "Trakya Kampüs 4.0", [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 27, color: Colors.white),
          ),
        ]),
        body: const Center(child: Text('Öğrenci bilgisi bulunamadı')),
      );
    }

    return Scaffold(
      appBar: trakyaAppBar(context, "Trakya Kampüs 4.0", [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 27, color: Colors.white),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Karekod Geçiş",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Center(
              child: Text(
                "$_remainingTime",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: TrakyaColors.primary,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: QrImageView(
                  padding: const EdgeInsets.all(50),
                  data: _qrPayload(
                    student.fullName,
                    student.studentNo,
                    student.faculty,
                    student.program,
                  ),
                  version: QrVersions.auto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
