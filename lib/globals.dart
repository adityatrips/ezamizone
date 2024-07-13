import 'package:flutter/material.dart';

class Globals {
  static const String username = "11330339";
  static const String password = "pratham@0510";
  static const textColor = Color(0xFFe6e2ed);
  static const backgroundColor = Color(0xFF08050d);
  static const primaryColor = Color(0xFFb093e5);
  static const primaryFgColor = Color(0xFF08050d);
  static const secondaryColor = Color(0xFF3f1093);
  static const secondaryFgColor = Color(0xFFe6e2ed);
  static const accentColor = Color(0xFF7529ff);
  static const accentFgColor = Color(0xFFe6e2ed);

  static ColorScheme darkTheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: primaryFgColor,
    secondary: secondaryColor,
    onSecondary: secondaryFgColor,
    tertiary: accentColor,
    onTertiary: accentFgColor,
    surface: backgroundColor,
    onSurface: textColor,
    error: Brightness.dark == Brightness.light
        ? Color(0xffB3261E)
        : Color(0xffF2B8B5),
    onError: Brightness.dark == Brightness.light
        ? Color(0xffFFFFFF)
        : Color(0xff601410),
  );

  static const textColorLight = Color(0xFF16121c);
  static const backgroundColorLight = Color(0xFFf4f0f9);
  static const primaryColorLight = Color(0xFF361a6b);
  static const primaryFgColorLight = Color(0xFFf4f0f9);
  static const secondaryColorLight = Color(0xFF9c6cef);
  static const secondaryFgColorLight = Color(0xFF16121c);
  static const accentColorLight = Color(0xFF4b00d6);
  static const accentFgColorLight = Color(0xFFf4f0f9);

  static ColorScheme lightTheme = const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColorLight,
    onPrimary: primaryFgColorLight,
    secondary: secondaryColorLight,
    onSecondary: secondaryFgColorLight,
    tertiary: accentColorLight,
    onTertiary: accentFgColorLight,
    surface: backgroundColorLight,
    onSurface: textColorLight,
    error: Brightness.light == Brightness.light
        ? Color(0xffB3261E)
        : Color(0xffF2B8B5),
    onError: Brightness.light == Brightness.light
        ? Color(0xffFFFFFF)
        : Color(0xff601410),
  );
}
