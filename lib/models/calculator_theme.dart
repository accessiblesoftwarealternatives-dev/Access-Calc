import 'package:flutter/material.dart';
import 'button_type.dart';
import 'button_style.dart';

class CalculatorTheme {
  final ButtonStyleData numberStyle;
  final ButtonStyleData operatorStyle;
  final ButtonStyleData functionStyle;
  final ButtonStyleData secondStyle;
  final ButtonStyleData alphaStyle;

  final Color backgroundColor;
  final Color displayColor;

  const CalculatorTheme({
    required this.numberStyle,
    required this.operatorStyle,
    required this.functionStyle,
    required this.secondStyle,
    required this.alphaStyle,
    required this.backgroundColor,
    required this.displayColor,
  });

  ButtonStyleData getStyle(ButtonType type) {
    switch (type) {
      case ButtonType.number:
        return numberStyle;
      case ButtonType.operator:
        return operatorStyle;
      case ButtonType.function:
        return functionStyle;
      case ButtonType.second:
        return secondStyle;
      case ButtonType.alpha:
        return alphaStyle;
    }
  }
}
