import 'package:flutter/material.dart';
import 'package:graphing_calculator/painters/calculator_painter.dart';
import '../models/calculator_buffer.dart';
import '../models/calculator_theme.dart';

class CalculatorDisplay extends StatelessWidget {
  final CalculatorTheme theme;
  final CalculatorBuffer buffer;

  const CalculatorDisplay({
    super.key,
    required this.theme,
    required this.buffer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.displayColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black54, width: 2),
      ),
      child: AnimatedBuilder(
        animation: buffer,
        builder: (_, __) {
          return CustomPaint(
            painter: CalculatorPainter(buffer: buffer),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
