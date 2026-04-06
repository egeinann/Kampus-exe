import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';

class QrView extends StatefulWidget {
  const QrView({super.key});

  @override
  State<QrView> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
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

  @override
  Widget build(BuildContext context) {
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
                  data:
                      "Ad: Ege Inan\nÖğrenci No: 1200707028\nOkul: İktisadi ve İdari Bilimler",
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
