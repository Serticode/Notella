import 'package:flutter/material.dart';

//!ELEMENT STYLES
//!TEXT STYLES
//!LOGIN AND REGISTER PAGE TEXT STYLE
final loginTitle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.w800,
  color: Colors.blue.shade900,
);

final textInputFieldLabelStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: Colors.grey.shade700,
);

//!TEXT FORM FIELD STYLE
final textFormFieldStyle = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  contentPadding: const EdgeInsets.all(12.0),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Colors.red.withRed(250),
      width: 1.5,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Colors.grey.shade700,
      width: 1.5,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Colors.blue.shade900,
      width: 1.5,
    ),
  ),
  hintStyle: TextStyle(
    color: Colors.grey,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  ),
);

final loginTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: Colors.blue.shade900,
);

final loginTextButtonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: Colors.blue.shade900,
  decoration: TextDecoration.underline,
  decorationColor: Colors.blue.shade900,
);

//!ELEVATED BUTTONS SECTION
var elevatedLoginButtonStyle = ElevatedButton.styleFrom(
  elevation: 10.0,
  primary: Colors.grey.shade200,
  padding: EdgeInsets.all(15.0),
  shadowColor: Colors.black.withOpacity(0.5),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide(color: Colors.blue.shade900, width: 2.0),
  ),
);

var elevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 10.0,
  primary: Colors.blue.shade900,
  padding: EdgeInsets.all(15.0),
  shadowColor: Colors.black.withOpacity(0.2),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

var elevatedButtonTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  letterSpacing: 1.5,
  color: Colors.white,
);

var registerScreenElevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 10.0,
  primary: Colors.white,
  padding: EdgeInsets.all(15.0),
  shadowColor: Colors.black.withOpacity(0.2),
  side: BorderSide(
    color: Colors.blue.shade900,
    width: 2.0,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

var registerScreenElevatedButtonTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w600,
  letterSpacing: 2.0,
  color: Color(0xFF002147),
);
