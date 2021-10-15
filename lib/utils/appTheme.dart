import 'package:flutter/material.dart';

/* Nav Color - #1B2737
Theme Color - #151E29
Tint Color - #1D8DEE
Status Bar - White
Text - White */

class AppTheme {
  get fetchLightTheme => appThemeLight();

  get darkModeBlueOne => Colors.blue.shade700;
  get darkModeBlueTwo => Colors.blue.shade900;
  ThemeData appThemeLight() {
    return ThemeData(
      canvasColor: Colors.grey.shade100,
      accentColor: Colors.grey.shade700,
      fontFamily: "Poppins",
      textTheme: TextTheme(
        subtitle1: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
        bodyText2: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade900,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0.0,
        backgroundColor: darkModeBlueTwo,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey.shade300,
        elevation: 0.0,
        contentTextStyle: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        elevation: 0.0,
        shadowColor: Colors.grey.shade300.withOpacity(0.5),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0.0,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey.shade700,
        unselectedIconTheme: IconThemeData(
          size: 20.0,
        ),
        selectedIconTheme: IconThemeData(
          size: 24.0,
        ),
      ),
    );
  }
}
