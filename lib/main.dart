import 'package:buscando_farmacias_chilenas/pantallas/pantalla_splash.dart';
import 'package:buscando_farmacias_chilenas/utils/custom_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscando Farmacias Chilenas',
      theme: ThemeData(
        primaryColor: CustomColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.primaryColor,
          secondary: CustomColors.secondaryColor,
          surface: CustomColors.backgroundColor,
        ),
        scaffoldBackgroundColor: CustomColors.backgroundColor,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 32.0, 
            fontWeight: FontWeight.bold, 
            color: CustomColors.primaryColor,
          ),
          titleLarge: TextStyle(
            fontSize: 20.0, 
            fontWeight: FontWeight.bold, 
            color: CustomColors.primaryColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14.0, 
            color: CustomColors.secondaryColor,
          ),
          labelLarge: TextStyle(
            fontSize: 16.0, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: CustomColors.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
      home: const PantallaSplash(),
    );
  }
}
