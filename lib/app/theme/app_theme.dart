import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => ThemeData(
        colorSchemeSeed: const Color(0xFF3157D5),
        useMaterial3: true,
      );

  static ThemeData dark() => ThemeData(
        colorSchemeSeed: const Color(0xFF8EA5FF),
        brightness: Brightness.dark,
        useMaterial3: true,
      );
}
