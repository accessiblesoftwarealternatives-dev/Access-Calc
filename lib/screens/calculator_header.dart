import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/button_mode.dart';

class CalculatorHeader extends StatelessWidget {
  final ButtonMode mode;

  const CalculatorHeader({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // future menu action
      },
      child: Container(
        height: 24,
        color: Colors.grey.shade500,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                "^",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft, // will be centerRight
              child: Text(
                _modeText(mode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _modeText(ButtonMode mode) {
    switch (mode) {
      case ButtonMode.normal:
        return "";
      case ButtonMode.second:
        return "↑";
      case ButtonMode.alpha:
        return "A";
    }
  }
}
