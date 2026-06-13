import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/calculator_buffer.dart';
import 'package:graphing_calculator/widgets/text_grid.dart';

class CalculatorPainter extends CustomPainter {
  final CalculatorBuffer buffer;

  CalculatorPainter({required this.buffer});

  static const int columns = 26;

  @override
  void paint(Canvas canvas, Size size) {
    final rowHeight = size.height / CalculatorBuffer.visibleLineCount;

    final textStyle = TextStyle(
      fontFamily: 'Courier',
      fontSize: rowHeight * 0.75,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      height: 1,
    );

    final visibleLines = buffer.visibleLines;

    final startRow = visibleLines.length < CalculatorBuffer.visibleLineCount
        ? 0
        : CalculatorBuffer.visibleLineCount - visibleLines.length;

    int row = startRow;

    for (final line in visibleLines) {
      String displayText = line.displayText;

      if (line.isResult) {
        if (displayText.length > columns) {
          displayText = displayText.substring(displayText.length - columns);
        }

        displayText = "." * (columns - displayText.length) + displayText;
      } else {
        if (displayText.length > columns) {
          displayText = displayText.substring(displayText.length - columns);
        }
      }

      TextGrid.drawRow(
        canvas: canvas,
        size: size,
        row: row,
        text: displayText,
        style: textStyle,
        columns: columns,
        visibleRows: CalculatorBuffer.visibleLineCount,
      );

      row++;
    }

    if (buffer.cursorVisible && buffer.isOnEditableLine) {
      final cursorRow = visibleLines.length < CalculatorBuffer.visibleLineCount
          ? (buffer.cursorRow - buffer.scrollOffset)
          : startRow + (buffer.cursorRow - buffer.scrollOffset);

      if (cursorRow >= 0 && cursorRow < CalculatorBuffer.visibleLineCount) {
        TextGrid.drawCursor(
          canvas: canvas,
          size: size,
          row: cursorRow,
          col: buffer.cursorColumn.clamp(0, columns - 1),
          columns: columns,
          visibleRows: CalculatorBuffer.visibleLineCount,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CalculatorPainter oldDelegate) {
    return true;
  }
}
