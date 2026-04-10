import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/constants/images.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/view/app/menu_view.dart';
import 'package:trakya_kampus_41/widgets/appBar.dart';
import 'package:trakya_kampus_41/widgets/button.dart';
import 'package:trakya_kampus_41/widgets/textfield.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(authProvider);

    final usernameController = TextEditingController(
      text: student == null
          ? ''
          : student.fullName.toLowerCase().replaceAll(' ', ''),
    );

    final passwordController = TextEditingController(text: student?.tcNo ?? '');

    bool reminderChecked = false;

    return Scaffold(
      backgroundColor: TrakyaColors.background,
      appBar: trakyaAppBar(context, "Trakya Kampüs 4.0", [
        Image.asset(TrakyaImages.news),
      ]),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(),
                forms(context, usernameController, passwordController),
                reminderMe(reminderChecked),
                underlineTexts(),
                customButton(
                  "Giriş",
                  Icons.login,
                  context,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MenuView()),
                  ),
                ),
                report(context),
                version(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column forms(
    BuildContext context,
    TextEditingController userCtrl,
    TextEditingController passCtrl,
  ) {
    return Column(
      spacing: 15,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TrakyaTextfield(
                textEditingController: userCtrl,
                context: context,
                prefixIcon: const Icon(Icons.person_outline_sharp),
                hintText: "Kullanıcı Adı",
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "@trakya.edu.tr",
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color.fromARGB(255, 40, 40, 40),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
        TrakyaTextfield(
          context: context,
          textEditingController: passCtrl,
          hasSuffixIcon: true,
          prefixIcon: const Icon(Icons.lock_outline),
          hintText: "Şifre",
        ),
      ],
    );
  }

  // uygulama version alanı
  Align version() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "version 11.0.0",
        style: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
        
          
        ),
      ),
    );
  }

  // öneri şikayet
  Row report(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.feedback_outlined, color: TrakyaColors.primary, size: 18),
        Text(
          "Öneri & Şikayet İlet",
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: TrakyaColors.primary.withAlpha(220),
            decoration: TextDecoration.underline,
            decorationThickness: 2,
            
           
          ),
        ),
      ],
    );
  }

  // beni hatırla
  Row reminderMe(bool reminderChecked) {
    return Row(
      children: [
        StatefulBuilder(
          builder: (context, setState) => Checkbox(
            value: reminderChecked,
            onChanged: (value) {
              setState(() {
                reminderChecked = !reminderChecked;
              });
            },
          ),
        ),

        Text(
          "Beni Hatırla",
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,

            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // altı çizgili metinler
  Column underlineTexts() {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        underlineText("KVKK Aydınlatma Metni"),
        underlineText("Eğitim Öğretim Yönetmeliği"),
        underlineText("2547 Sayılı Kanun Maddesi"),
        underlineText("Öğrenci El Kitabı"),
      ],
    );
  }

  // başlık
  Align title() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "Giriş",
        style: GoogleFonts.roboto(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget underlineText(String text) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w800,
        decoration: TextDecoration.underline,
        decorationThickness: 2,
      
        fontSize: 16.sp,
      ),
    );
  }
}
