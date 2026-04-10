import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/constants/images.dart';

PreferredSizeWidget trakyaAppBar(
  BuildContext context,
  String title,
  List<Widget>? actions, {
  Color? backgroundColor,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(65),
    child: Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? TrakyaColors.primary,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30)),
      ),
      child: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Image.asset(TrakyaImages.logo),
        ),
        actionsPadding: const EdgeInsets.all(12),
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        actions: actions,
        centerTitle: true,
      ),
    ),
  );
}
