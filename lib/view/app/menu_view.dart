import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/constants/images.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/view/app/digitalIdentity_view.dart';
import 'package:trakya_kampus_41/view/app/education_view.dart';
import 'package:trakya_kampus_41/view/app/healtAndSport_view.dart';
import 'package:trakya_kampus_41/view/app/qr_view.dart';
import 'package:trakya_kampus_41/view/auth/login_view.dart';
import 'package:trakya_kampus_41/view/profile/editProfile_view.dart';

class MenuView extends ConsumerWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: TrakyaColors.primary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        actionsPadding: EdgeInsets.all(10),
        leading: Image.asset(TrakyaImages.logo),
        title: Transform.translate(
          offset: const Offset(50, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student?.fullName.toUpperCase() ?? "",
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "OGRENCI",
                style:  GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _showExitDialog(context),
            child: Icon(Icons.logout, size: 28, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            TrakyaImages.menuBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: -140,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                TrakyaImages.logo,
                fit: BoxFit.scaleDown,
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.35,
              ),
            ),
          ),
          Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  spacing: 25,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileView(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.description_outlined,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QrView()),
                      ),
                      child: Icon(
                        Icons.qr_code_2,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.restaurant, size: 45, color: Colors.white),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: const Offset(-10, -20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EducationView(),
                            ),
                          );
                        },
                        child: Image.asset(
                          TrakyaImages.menuContainer1,
                          width: MediaQuery.of(context).size.width * 0.85,
                          alignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -120),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HealtAndSportView(),
                            ),
                          );
                        },
                        child: Image.asset(
                          TrakyaImages.menuContainer2,
                          width: MediaQuery.of(context).size.width * 0.80,
                          alignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -220),
                      child: Image.asset(
                        TrakyaImages.menuContainer3,
                        width: MediaQuery.of(context).size.width * 0.75,
                        alignment: Alignment.topLeft,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(-10, -320),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DigitalIdentityView(),
                            ),
                          );
                        },
                        child: Image.asset(
                          TrakyaImages.menuContainer4,
                          width: MediaQuery.of(context).size.width * 0.70,
                          alignment: Alignment.topLeft,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Çıkmak istediğinize\nemin misiniz?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: "roboto",
                ),
                textAlign: TextAlign.center,
              ),
              Divider(),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        backgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Text(
                          "Vazgeç",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "roboto",
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        elevation: 0,
                        backgroundColor: TrakyaColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Text(
                          "Evet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: TrakyaColors.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
