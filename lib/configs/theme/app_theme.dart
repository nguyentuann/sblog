import 'package:flutter/material.dart';
import 'package:sblog/configs/theme/color.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 252, 252, 252),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: 'OpenSans',
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
    ),

    /// Cấu hình InputDecoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GeneralColors.wColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      labelStyle: const TextStyle(color: GeneralColors.blColor),
      hintStyle: const TextStyle(fontSize: 12, color: TextColors.text),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 0.5, color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1, color: GeneralColors.grColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1, color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 2, color: Colors.redAccent),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
    ),

    /// Cấu hình nút ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(GeneralColors.bColor),
        foregroundColor: WidgetStateProperty.all(GeneralColors.wColor),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ),

    /// Cấu hình TextTheme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: TextColors.text,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: TextColors.text,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: TextColors.text,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: TextColors.text,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: TextColors.text),
      labelSmall: TextStyle(fontSize: 12, color: TextColors.text),
    ),

    /// Cấu hình AppBarTheme
    appBarTheme: const AppBarTheme(
      backgroundColor: GeneralColors.wColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: TextColors.text,
      ),
      iconTheme: IconThemeData(color: TextColors.text),
    ),

    /// Cấu hình IconTheme
    iconTheme: const IconThemeData(color: TextColors.text, size: 24),

    /// Cấu hình BottomAppBarTheme
    bottomAppBarTheme: const BottomAppBarTheme(
      color: GeneralColors.wColor,
      elevation: 0,
    ),

    /// Cấu hình BottomNavigationBarTheme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: GeneralColors.wColor,
      selectedItemColor: GeneralColors.blColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: GeneralColors.bColor,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: GeneralColors.blColor,
    scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
    brightness: Brightness.dark,
    fontFamily: 'OpenSans',
    
    /// Cấu hình TextSelection cho dark theme
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white24,
      selectionHandleColor: Colors.white70,
    ),

    /// Cấu hình InputDecoration cho dark theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E), // Dark input background
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(fontSize: 12, color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24, width: 0.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 0.5, color: Colors.white12),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1, color: Colors.blueAccent),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 1, color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 14),
    ),

    /// Cấu hình ElevatedButton cho dark theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFF2196F3)), // Blue button
        foregroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(2),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ),

    /// Cấu hình TextTheme cho dark theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 14, color: Colors.white60),
      labelSmall: TextStyle(fontSize: 12, color: Colors.white60),
    ),

    /// Cấu hình AppBarTheme cho dark theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    /// Cấu hình IconTheme cho dark theme
    iconTheme: const IconThemeData(color: Colors.white70, size: 24),

    /// Cấu hình BottomAppBarTheme cho dark theme
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFF1E1E1E),
      elevation: 8,
    ),

    /// Cấu hình BottomNavigationBarTheme cho dark theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.white54,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    /// Cấu hình ProgressIndicator cho dark theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.blueAccent,
    ),

    /// Cấu hình Card cho dark theme
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    /// Cấu hình Dialog cho dark theme
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    /// Cấu hình Divider cho dark theme
    dividerTheme: const DividerThemeData(
      color: Colors.white24,
      thickness: 0.5,
    ),

    /// Cấu hình ListTile cho dark theme
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white70,
      iconColor: Colors.white70,
      tileColor: Color(0xFF1E1E1E),
    ),

    /// Cấu hình FloatingActionButton cho dark theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      elevation: 6,
    ),

    /// Cấu hình Switch cho dark theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blueAccent;
        }
        return Colors.white70;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blueAccent.withOpacity(0.5);
        }
        return Colors.white24;
      }),
    ),

    /// Cấu hình Checkbox cho dark theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blueAccent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: Colors.white54, width: 2),
    ),

    /// Cấu hình Radio cho dark theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blueAccent;
        }
        return Colors.white54;
      }),
    ),

    /// Cấu hình Slider cho dark theme
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.blueAccent,
      inactiveTrackColor: Colors.white24,
      thumbColor: Colors.blueAccent,
      overlayColor: Colors.blueAccent.withOpacity(0.2),
      valueIndicatorColor: Colors.blueAccent,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    ),

    /// Cấu hình SnackBar cho dark theme
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF323232),
      contentTextStyle: TextStyle(color: Colors.white),
      actionTextColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    /// Cấu hình TabBar cho dark theme
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      indicatorColor: Colors.blueAccent,
      dividerColor: Colors.transparent,
    ),

    /// Cấu hình Tooltip cho dark theme
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(
        color: Color(0xFF424242),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textStyle: TextStyle(color: Colors.white),
    ),
  );
}