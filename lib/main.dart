import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/view/auth/register_view.dart';
import 'package:trakya_kampus_41/view/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  TrakyaColors.setDarkMode(false);

  runApp(const ProviderScope(child: TrakyaKampus41()));
}

class TrakyaKampus41 extends ConsumerWidget {
  const TrakyaKampus41({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(authProvider);

    return ScreenUtilInit(
      designSize: const Size(393, 852), //  iPhone 15 base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            // GLOBAL FONT SYSTEM (çok önemli)
            textTheme: GoogleFonts.robotoTextTheme(),

            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),

          home: student == null ? const RegisterView() : const LoginView(),
        );
      },
    );
  }
}