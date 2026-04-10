import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trakya_kampus_41/constants/colors.dart';

import 'package:trakya_kampus_41/constants/images.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';

class EducationView extends StatelessWidget {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TrakyaColors.background,
      appBar: trakyaAppBar(context, "Trakya Kampüs 4.0", [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 27, color: Colors.white),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Eğitim",
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  
                ),
              ),
            ),
            Image.asset(TrakyaImages.courseSchedule),
            Image.asset(TrakyaImages.electronicAttendance),
            Image.asset(TrakyaImages.rollCall),
          ],
        ),
      ),
    );
  }
}
