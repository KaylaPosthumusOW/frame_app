import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sp_utilities/utilities.dart';

const kDefaultThemeMode = ThemeMode.light;

class FrameTheme {
  static TextTheme get textTheme {
    return GoogleFonts.lexendTextTheme().copyWith(
      displayLarge: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black),
      displayMedium: GoogleFonts.lexend(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
      displaySmall: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      headlineLarge: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
      headlineMedium: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
      headlineSmall: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
      titleLarge: GoogleFonts.lexend(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
      titleMedium: GoogleFonts.lexend(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
      titleSmall: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      labelLarge: GoogleFonts.lexend(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      labelMedium: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
      labelSmall: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
      bodyLarge: GoogleFonts.lexend(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
      bodyMedium: GoogleFonts.lexend(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
      bodySmall: GoogleFonts.lexend(fontSize: 10, fontWeight: FontWeight.w300, color: Colors.black),
    );
  }

  static ThemeData lightTheme(bool useMaterial3) {
    return ThemeData(
      textTheme: textTheme,
      useMaterial3: useMaterial3,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.ubLightGrey,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        foregroundColor: Colors.black,
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black, size: 33),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 33),
      colorScheme: ColorScheme.light(
        primary: AppColors.ubOrange,
        secondary: AppColors.ubDarkOrange,
        surface: AppColors.ubLightGrey,
        error: AppColors.ubOrange.withValues(alpha: 0.5),
        onPrimary: AppColors.ubWhite,
        onSecondary: AppColors.ubWhite,
        onSurface: AppColors.ubWhite,
        onError: AppColors.ubOrange.withValues(alpha: 0.5),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.ubOrange, width: 2),
        ),
        labelColor: AppColors.ubOrange,
        unselectedLabelColor: AppColors.ubWhite,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: AppColors.ubLightGrey,
        selectedColor: AppColors.ubOrange,
        fillColor: AppColors.ubLightGrey,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.ubGrey),
        trackColor: WidgetStateProperty.all(AppColors.ubLightGrey),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.ubDarkBlue,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.displayLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.ubOrange,
        textColor: Colors.black,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.ubWhite),
        checkColor: WidgetStateProperty.all(AppColors.ubOrange),
      ),
      dividerTheme: DividerThemeData(color: AppColors.ubGrey),
      splashColor: Colors.transparent,
      cardTheme: CardThemeData(
        color: AppColors.ubWhite,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.ubOrange,
        textStyle: textTheme.labelMedium?.copyWith(color: Colors.white),
        textColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(bool useMaterial3) {
    return ThemeData(
      textTheme: textTheme,
      useMaterial3: useMaterial3,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.ubDarkBlue,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black, size: 33),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 33),
      colorScheme: ColorScheme.dark(
        primary: AppColors.ubOrange,
        secondary: AppColors.ubDarkOrange,
        surface: AppColors.ubLightGrey,
        error: AppColors.ubOrange.withValues(alpha: 0.5),
        onPrimary: AppColors.ubWhite,
        onSecondary: AppColors.ubWhite,
        onSurface: AppColors.ubWhite,
        onError: AppColors.ubOrange.withValues(alpha: 0.5),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.ubOrange, width: 2),
        ),
        labelColor: AppColors.ubOrange,
        unselectedLabelColor: AppColors.ubWhite,
        labelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: AppColors.ubLightGrey,
        selectedColor: AppColors.ubOrange,
        fillColor: AppColors.ubLightGrey,
        borderRadius: BorderRadius.circular(8),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.ubGrey),
        trackColor: WidgetStateProperty.all(AppColors.ubLightGrey),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.ubDarkBlue,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          textTheme.displayLarge,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.ubOrange,
        textColor: Colors.black,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(AppColors.ubWhite),
        checkColor: WidgetStateProperty.all(AppColors.ubOrange),
      ),
      dividerTheme: DividerThemeData(color: AppColors.ubGrey),
      splashColor: Colors.transparent,
      cardTheme: CardThemeData(
        color: AppColors.ubWhite,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class AppColors {
  static Color ubDarkOrange = HexColor('#BA3300');
  static Color ubOrange = HexColor('#FC5F23');
  static Color ubDarkBlue = HexColor('#101938');
  static Color ubGrey = HexColor('#B3B3B3');
  static Color ubLightGrey = HexColor('#EDEDED');
  static Color ubWhite = HexColor('#FFFFFF');
  static Color ubTimelineGrey = HexColor('#D9D9D9');
  static Color ubPurple = HexColor('#9747FF');
  static Color ubRed = HexColor('#FF0000');
}

List<BoxShadow> getBoxShadow(BuildContext context) {
  return [
    BoxShadow(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.16), blurStyle: BlurStyle.normal, offset: const Offset(0, 1), blurRadius: 3),
  ];
}
