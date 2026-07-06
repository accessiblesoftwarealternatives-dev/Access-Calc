import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/calc_error.dart';
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

    if (buffer.error != null) {
      _paintError(canvas, size, textStyle, buffer.error!);
      return;
    }

    final visibleLines = buffer.visibleLines;

    final startRow = visibleLines.length < CalculatorBuffer.visibleLineCount
        ? 0
        : CalculatorBuffer.visibleLineCount - visibleLines.length;

    int row = startRow;

    for (final line in visibleLines) {
      String displayText = line.displayText;
      int contentStart = 0;
      int contentWidth;
      String dots = '';

      if (line.isResult) {
        if (displayText.length > columns) {
          displayText = displayText.substring(displayText.length - columns);
        }
        contentWidth = displayText.length;
        contentStart = columns - contentWidth;
        dots = "." * contentStart;
      } else {
        if (displayText.length > columns) {
          displayText = displayText.substring(displayText.length - columns);
        }
        contentWidth = displayText.length;
        contentStart = 0;
      }

      final actualRow = buffer.scrollOffset + (row - startRow);
      final isHighlighted =
          !buffer.isOnEditableLine && actualRow == buffer.cursorRow;

      if (isHighlighted) {
        TextGrid.drawHighlight(
          canvas: canvas,
          size: size,
          row: row,
          startCol: contentStart,
          width: contentWidth,
          columns: columns,
          visibleRows: CalculatorBuffer.visibleLineCount,
        );
      }

      if (dots.isNotEmpty) {
        TextGrid.drawRow(
          canvas: canvas,
          size: size,
          row: row,
          text: dots,
          style: textStyle,
          columns: columns,
          visibleRows: CalculatorBuffer.visibleLineCount,
        );
      }

      TextGrid.drawRow(
        canvas: canvas,
        size: size,
        row: row,
        text: displayText,
        style: isHighlighted
            ? textStyle.copyWith(color: const Color(0xFFD8E0C8))
            : textStyle,
        columns: columns,
        visibleRows: CalculatorBuffer.visibleLineCount,
        startCol: contentStart,
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
          mode: buffer.mode,
        );
      }
    }
  }

  void _paintError(
    Canvas canvas,
    Size size,
    TextStyle textStyle,
    CalcError error,
  ) {
    const visibleRows = CalculatorBuffer.visibleLineCount;
    final cellHeight = size.height / visibleRows;
    final cellWidth = size.width / columns;

    var row = 0;
    final title = 'ERROR: ${error.title}';

    TextGrid.drawRow(
      canvas: canvas,
      size: size,
      row: row,
      text: title,
      style: textStyle,
      columns: columns,
      visibleRows: visibleRows,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, (row + 1) * cellHeight - 2, title.length * cellWidth, 2),
      Paint()..color = Colors.black,
    );

    row += 2;
    _drawMenuOption(canvas, size, textStyle, row, '1', 'Quit');
    row++;
    _drawMenuOption(canvas, size, textStyle, row, '2', 'Goto');
    row += 2;

    for (final line in error.message.split('\n')) {
      TextGrid.drawRow(
        canvas: canvas,
        size: size,
        row: row,
        text: line,
        style: textStyle,
        columns: columns,
        visibleRows: visibleRows,
      );
      row++;
    }
  }

  void _drawMenuOption(
    Canvas canvas,
    Size size,
    TextStyle textStyle,
    int row,
    String number,
    String label,
  ) {
    TextGrid.drawHighlight(
      canvas: canvas,
      size: size,
      row: row,
      startCol: 0,
      width: 1,
      columns: columns,
      visibleRows: CalculatorBuffer.visibleLineCount,
    );

    TextGrid.drawRow(
      canvas: canvas,
      size: size,
      row: row,
      text: number,
      style: textStyle.copyWith(color: const Color(0xFFD8E0C8)),
      columns: columns,
      visibleRows: CalculatorBuffer.visibleLineCount,
    );

    TextGrid.drawRow(
      canvas: canvas,
      size: size,
      row: row,
      text: ':$label',
      style: textStyle,
      columns: columns,
      visibleRows: CalculatorBuffer.visibleLineCount,
      startCol: 1,
    );
  }

  @override
  bool shouldRepaint(covariant CalculatorPainter oldDelegate) {
    return true;
  }
}
