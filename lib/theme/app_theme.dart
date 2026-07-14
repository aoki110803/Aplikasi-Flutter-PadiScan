import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Palet Hijau Padi
  static const primary       = Color(0xFF1A6B3A);  // Hijau tua
  static const primaryLight  = Color(0xFF4CAF50);  // Hijau medium
  static const primaryPale   = Color(0xFFE8F5E9);  // Hijau pucat
  static const accent        = Color(0xFFF9A825);  // Emas/Gold
  static const accentLight   = Color(0xFFFFF8E1);
  static const background    = Color(0xFFF4F7F5);  // Abu kehijauan
  static const surface       = Color(0xFFFFFFFF);
  static const textPrimary   = Color(0xFF1A2E1A);
  static const textSecondary = Color(0xFF5F6368);
  static const error         = Color(0xFFD32F2F);
  static const success       = Color(0xFF2E7D32);
  static const warning       = Color(0xFFF57F17);
  static const cardShadow    = Color(0x141A6B3A);
  static const borderLight = primaryPale;
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.surface,
      background: AppColors.background,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.w600,
        ),
        elevation: 2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primaryPale,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.textSecondary),
      prefixIconColor: AppColors.primary,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primaryPale, width: 1),
      ),
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
}

// Widget helper: Card Premium
class PadiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const PadiCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.primaryPale),
      boxShadow: [BoxShadow(
        color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0,4)
      )],
    ),
    child: child,
  );
}
