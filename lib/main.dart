import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- WAJIB UNTUK TANGGAL INDONESIA
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_colors.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==============================================
  //  FIX ERROR TANGGAL INDONESIA (WAJIB)
  // ==============================================
  await initializeDateFormatting('id_ID', null);

  // ==============================================
  //  SUPABASE INIT
  // ==============================================
  await Supabase.initialize(
    url: 'https://svosrxzprmyjsruomofm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN2b3NyeHpwcm15anNydW9tb2ZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzMDI1MDcsImV4cCI6MjA3Njg3ODUwN30.ylkvAzZ03D_gvOK_sbO9YH15GeX5HMl-xNIODx5su14',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,

      // ===================================
      //  iOS CLEAN BACKGROUND
      // ===================================
      scaffoldBackgroundColor: const Color(0xFFF2F2F7),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),

      // ===================================
      //  iOS ELEGANT APP BAR
      // ===================================
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF2F2F7),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),

      // ===================================
      //  TEXT THEME CLEAN MODERN
      // ===================================
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyMedium: GoogleFonts.poppins(color: Colors.black87, fontSize: 15),
      ),
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
