import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:trakya_kampus_41/constants/colors.dart';
import 'package:trakya_kampus_41/providers/auth_notifier.dart';
import 'package:trakya_kampus_41/view/auth/register_view.dart';
import 'package:trakya_kampus_41/view/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sadece dikey (portrait) izin ver
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Uygulama başlamadan önce açık veya koyu tema belirlenebilir
  TrakyaColors.setDarkMode(false);

  runApp(const ProviderScope(child: TrakyaKampus41()));
}

class TrakyaKampus41 extends ConsumerWidget {
  const TrakyaKampus41({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(authProvider);

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: student == null ? const RegisterView() : const LoginView(),
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
        );
      },
    );
  }
}
