import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_colors.dart';
import './app/routes/app_pages.dart';
import './app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ozgzwarpjsyucmyjwibp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96Z3p3YXJwanN5dWNteWp3aWJwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ5NDE1MzUsImV4cCI6MjA4MDUxNzUzNX0.uj_R_fO4KnyizQ2t1QES1JJRPquYO8ZjO5rLBObQaJs',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );

    return GetMaterialApp(
      title: "Absensi Santri QR",
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: AppRoutes.attendance,
      getPages: AppPages.pages,
    );
  }
}
