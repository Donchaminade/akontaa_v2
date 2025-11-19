import 'package:akontaa/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF6200EE), // A slightly deeper purple for primary
  scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Soft off-white
  colorScheme: ColorScheme.light(
    primary: const Color(0xFF6200EE),
    secondary: AppColors.green, // Green for accent
    surface: Colors.white,
    error: AppColors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // Solid white app bar
    elevation: 2, // Subtle elevation
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.black87),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2, // Reduced elevation
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.green, // Green for FAB in light mode
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineSmall:
        TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.green, width: 2.0),
    ),
    filled: true,
    fillColor: Colors.grey[100],
  ),
);

// final lightTheme = ThemeData(
//   brightness: Brightness.light,

//   // Couleurs principales — on garde l'accent vert mais on le tempère légèrement
//   primaryColor: const Color.fromARGB(
//       255, 140, 195, 8), // un vert un peu moins fluorescent
//   scaffoldBackgroundColor: const Color(0xFFF6F7F8), // fond doux (pas blanc pur)

//   // Color scheme complet
//   colorScheme: ColorScheme.light(
//     primary: const Color.fromARGB(255, 140, 195, 8),
//     onPrimary: Colors.black, // lisible sur le vert clair
//     secondary:
//         AppColors.green, // ton vert central (peut pointer sur la même valeur)
//     onSecondary: Colors.white,
//     surface: Colors.white,
//     onSurface: Colors.black87,
//     background: const Color(0xFFF6F7F8),
//     error: AppColors.red,
//     onError: Colors.white,
//   ),

//   // AppBar : léger, avec blur / shadow subtil
//   appBarTheme: AppBarTheme(
//     backgroundColor: Colors.white,
//     elevation: 2,
//     centerTitle: false,
//     titleTextStyle: const TextStyle(
//       color: Colors.black87,
//       fontSize: 20,
//       fontWeight: FontWeight.w700,
//     ),
//     iconTheme: const IconThemeData(color: Colors.black87),
//     toolbarHeight: 56,
//     systemOverlayStyle: SystemUiOverlayStyle.dark,
//   ),

//   // Cards / surfaces
//   cardTheme: CardThemeData(
//     color: Colors.white,
//     elevation: 3,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//   ),

//   // Boutons : cohérence entre Elevated / Outlined / Text
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color.fromARGB(255, 140, 195, 8),
//       foregroundColor: Colors.black,
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//     ),
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: OutlinedButton.styleFrom(
//       foregroundColor: Colors.black87,
//       side: BorderSide(color: Colors.black12),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//   ),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       foregroundColor: const Color.fromARGB(255, 140, 195, 8),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//     ),
//   ),

//   // Floating action button
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: Color.fromARGB(255, 140, 195, 8),
//     foregroundColor: Colors.black,
//     elevation: 4,
//   ),

//   // Inputs
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: const Color(0xFFF2F4F6),
//     contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.black12, width: 1),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: Colors.black12, width: 1),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide:
//           BorderSide(color: const Color.fromARGB(255, 140, 195, 8), width: 2),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide(color: AppColors.red, width: 1.5),
//     ),
//     hintStyle: TextStyle(color: Colors.black45),
//   ),

//   // Typographie — tailles raisonnables et poids
//   textTheme: const TextTheme(
//     headlineSmall: TextStyle(
//         fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
//     titleLarge: TextStyle(
//         fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
//     bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
//     bodySmall: TextStyle(fontSize: 13, color: Colors.black26),
//     labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//   ),

//   // Icones, dividers, snackbars, bottom nav
//   iconTheme: const IconThemeData(color: Colors.black87, size: 20),
//   dividerTheme: const DividerThemeData(color: Color(0xFFE6E9EC), thickness: 1),
//   snackBarTheme: SnackBarThemeData(
//     backgroundColor: Colors.black87,
//     contentTextStyle: const TextStyle(color: Colors.white),
//     behavior: SnackBarBehavior.floating,
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     backgroundColor: Colors.white,
//     selectedItemColor: const Color.fromARGB(255, 140, 195, 8),
//     unselectedItemColor: Colors.black54,
//     elevation: 8,
//     showUnselectedLabels: true,
//   ),

//   // Comportement adaptatif / densité
//   visualDensity: VisualDensity.adaptivePlatformDensity,

//   // States (hover/focus) - valeurs utilitaires
//   focusColor: const Color.fromARGB(40, 140, 195, 8),
//   hoverColor: const Color(0xFFEFF6EA),
//   disabledColor: Colors.black26,
// );

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 162, 228, 9),
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 162, 228, 9),
    secondary: AppColors.green,
    surface: const Color(0xFF1E1E1E),
    error: AppColors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.green,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.green, width: 2.0),
    ),
    filled: true,
    fillColor: const Color(0xFF2A2A2A),
  ),
);
