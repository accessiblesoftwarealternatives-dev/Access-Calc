import 'package:flutter/material.dart';
import '../models/calculator_theme.dart';
import '../models/button_style.dart';

const ti84Theme = CalculatorTheme(
  numberStyle: ButtonStyleData(
    backgroundColor: Color(0xFFD0D2D2),
    textColor: Color(0xFF030505),
  ),
  operatorStyle: ButtonStyleData(
    backgroundColor: Color(0xFFD0D2D2),
    textColor: Color(0xFF030505),
  ),
  functionStyle: ButtonStyleData(
    backgroundColor: Color(0xFF171717),
    textColor: Color(0xFFFCFCFC),
  ),
  secondStyle: ButtonStyleData(
    backgroundColor: Color(0xFF005EA8),
    textColor: Colors.white,
  ),
  alphaStyle: ButtonStyleData(
    backgroundColor: Color(0xFF7DBA2A),
    textColor: Colors.white,
  ),
  backgroundColor: Color(0xFF373737),
  displayColor: Colors.white,
);
