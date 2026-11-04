import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Token warna sesuai Cyclefy Design System v1.0 (Draft), bagian 2.
class AppColors {
  AppColors._();

  // Warna utama
  static const Color green900 = Color(0xFF174B2B); // header gelap, footer
  static const Color green700 = Color(0xFF267A43); // tombol utama, link aktif
  static const Color green500 = Color(0xFF3FA65B); // ikon aktif, aksen
  static const Color green100 = Color(0xFFE6F4E9); // background section, badge

  // Warna netral
  static const Color white = Color(0xFFFFFFFF); // background utama dan card
  static const Color gray50 = Color(0xFFF8FAF8); // background halaman
  static const Color gray100 = Color(0xFFEEF1EF); // background input
  static const Color gray300 = Color(0xFFD5DDD7); // border dan divider
  static const Color gray600 = Color(0xFF66736A); // teks sekunder
  static const Color gray900 = Color(0xFF202B23); // teks utama

  // Warna semantik (selalu sertakan teks/ikon, jangan warna saja)
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFDC9A20);
  static const Color error = Color(0xFFDC4545);
  static const Color info = Color(0xFF3182CE);
}

/// Token spacing (kelipatan 4 px), bagian 5.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4; // jarak ikon dan teks
  static const double sm = 8; // jarak elemen kecil
  static const double md = 12; // jarak label dan input
  static const double lg = 16; // padding komponen
  static const double xl = 24; // jarak antar komponen
  static const double xl2 = 32; // jarak antar section
  static const double xl3 = 48; // jarak section besar
  static const double xl4 = 64; // jarak antar bagian halaman

  /// Margin samping halaman pada mobile (bagian 4).
  static const double pageMargin = 16;
}

/// Token border radius, bagian 6.
class AppRadius {
  AppRadius._();

  static const double sm = 4; // label kecil
  static const double md = 8; // input dan tombol
  static const double lg = 12; // card
  static const double xl = 16; // modal dan panel
  static const double full = 999; // avatar dan badge pil
}

/// Ukuran komponen.
class AppSizes {
  AppSizes._();

  /// Tinggi tombol standar 44-48 px (bagian 7.1).
  static const double buttonHeight = 48;
  static const double iconSize = 20; // ikon standar 20 atau 24 px
}

/// ThemeData aplikasi Cyclefy.
class AppTheme {
  AppTheme._();

  // Hierarki tipografi, bagian 3 (H1 32/700, H2 24/600, H3 20/600,
  // H4 18/600, Body 16/400, Small 14/400, Caption 12/400).
  static const TextTheme _baseTextTheme = TextTheme(
    headlineLarge:
        TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.25),
    headlineMedium:
        TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3),
    headlineSmall:
        TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
    titleLarge:
        TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
    titleMedium:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
    titleSmall:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
    bodyLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge:
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.25),
    labelMedium:
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
    labelSmall:
        TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.3),
  );

  static ThemeData light() {
    final TextTheme textTheme = GoogleFonts.interTextTheme(
      _baseTextTheme.apply(
        bodyColor: AppColors.gray900,
        displayColor: AppColors.gray900,
      ),
    );

    const ColorScheme colorScheme = ColorScheme.light(
      primary: AppColors.green700,
      onPrimary: AppColors.white,
      secondary: AppColors.green500,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.gray900,
      outline: AppColors.gray300,
    );

    final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );

    OutlineInputBorder inputBorder(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.gray50,
      textTheme: textTheme,
      dividerTheme: const DividerThemeData(color: AppColors.gray300),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.green700),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.green900,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle:
            textTheme.titleLarge?.copyWith(color: AppColors.white),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 1, // shadow tipis
        shadowColor: AppColors.gray900,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.green700 : null,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
        errorStyle: textTheme.labelSmall?.copyWith(color: AppColors.error),
        border: inputBorder(AppColors.gray300),
        enabledBorder: inputBorder(AppColors.gray300),
        disabledBorder: inputBorder(AppColors.gray300),
        focusedBorder: inputBorder(AppColors.green700, width: 2),
        errorBorder: inputBorder(AppColors.error),
        focusedErrorBorder: inputBorder(AppColors.error, width: 2),
      ),
      // Primary: Green 700, teks putih.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.green700,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.gray300,
          disabledForegroundColor: AppColors.gray600,
          minimumSize: const Size(64, AppSizes.buttonHeight),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      // Secondary: border Green 700, teks hijau.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.green700,
          disabledForegroundColor: AppColors.gray600,
          minimumSize: const Size(64, AppSizes.buttonHeight),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ).copyWith(
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? AppColors.gray300
                  : AppColors.green700,
            ),
          ),
        ),
      ),
      // Tertiary: tanpa bidang warna, teks hijau.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.green700,
          disabledForegroundColor: AppColors.gray600,
          minimumSize: const Size(64, AppSizes.buttonHeight),
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }
}