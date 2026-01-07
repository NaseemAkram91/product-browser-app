import 'package:flutter/material.dart';

/// Extension on [BuildContext] for theme-related operations
extension ThemeExtension on BuildContext {
  /// Returns the current [ThemeData]
  ThemeData get theme => Theme.of(this);

  /// Returns the current [ColorScheme]
  ColorScheme get colors => theme.colorScheme;

  /// Returns the current text theme
  TextStyle? get headlineMedium => theme.textTheme.headlineMedium;

  /// Returns the current body medium text style
  TextStyle? get bodyMedium => theme.textTheme.bodyMedium;

  /// Checks if the current theme is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
