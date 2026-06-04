import 'package:flutter/material.dart';

class TextGrid {
  static final Map<String, TextPainter> _cache = {};

  static void drawRow({
    required Canvas canvas,
    required Size size,
    required int row,
    required String text,
    required TextStyle style,
    required int columns,
    required int visibleRows,
  }) {
    final cellWidth = size.width / columns;
    final cellHeight = size.height / visibleRows;

    final chars = text.characters.toList();

    for (int col = 0; col < chars.length && col < columns; col++) {
      _drawCharacter(
        canvas: canvas,
        char: chars[col],
        col: col,
        row: row,
        cellWidth: cellWidth,
        cellHeight: cellHeight,
        style: style,
      );
    }
  }

  static void drawCursor({
    required Canvas canvas,
    required Size size,
    required int row,
    required int col,
    required int columns,
    required int visibleRows,
  }) {
    final cellWidth = size.width / columns;
    final cellHeight = size.height / visibleRows;

    canvas.drawRect(
      Rect.fromLTWH(col * cellWidth, row * cellHeight, cellWidth, cellHeight),
      Paint()..color = Colors.black.withValues(alpha: 0.45),
    );
  }

  static void _drawCharacter({
    required Canvas canvas,
    required String char,
    required int col,
    required int row,
    required double cellWidth,
    required double cellHeight,
    required TextStyle style,
  }) {
    final key = '${style.fontFamily}_${style.fontSize}_$char';

    final painter =
        _cache[key] ??
        (_cache[key] = TextPainter(
          text: TextSpan(text: char, style: style),
          textDirection: TextDirection.ltr,
        )..layout());

    final x = col * cellWidth + 1;

    final y = row * cellHeight + (cellHeight - painter.height) / 2;

    painter.paint(canvas, Offset(x, y));
  }
}
