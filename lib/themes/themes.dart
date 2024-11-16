import 'package:flutter/material.dart';

class Themes {
  //static const defaultPrimaryColor = Color(0xFF2c48d3);
//  static const defaultPrimaryColor = Color(0xFF1e3d86);
//  static const defaultSecondaryColor = Color(0xFFa65bff);
//  static const defaultTertiaryColor = Color(0xFFe7ad3a);

  //RAMA
  static const defaultPrimaryColor = Color(0xFF235255);
  static const defaultSecondaryColor = Color(0xFFEBDE55);
  static const defaultTertiaryColor = Color(0xFF1E3063);




  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: defaultPrimaryColor,
      secondary: defaultSecondaryColor,
      tertiary: defaultTertiaryColor,
      tertiaryContainer: Color.fromARGB(255, 241, 198, 110),
      brightness: Brightness.light,
    ),
    fontFamily: 'Anuphan',
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: defaultPrimaryColor,
      secondary: defaultSecondaryColor,
      tertiary: defaultTertiaryColor,
      tertiaryContainer: Color.fromARGB(255, 252, 210, 126),
      onTertiaryContainer: Color.fromARGB(255, 80, 58, 14),
      brightness: Brightness.dark,
    ),
    fontFamily: 'Anuphan',
  );
}
