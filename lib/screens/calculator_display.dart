import 'package:flutter/material.dart';
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

  static const double fontSize = 22;
  static const double lineHeight = 1.2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.displayColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black54, width: 2),
      ),
      child: AnimatedBuilder(
        animation: buffer,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  ClipRect(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: _buildLines(constraints.maxWidth),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildLines(double maxWidth) {
    final widgets = <Widget>[];

    for (int i = 0; i < buffer.visibleLines.length; i++) {
      final line = buffer.visibleLines[i];
      final actualRow = i + buffer.scrollOffset;

      final isCurrentLine = actualRow == buffer.cursorRow;
      final isEditable = buffer.isOnEditableLine;

      final textWidth = _measureTextWidth(line.text);

      widgets.add(
        SizedBox(
          height: fontSize * lineHeight,
          child: Stack(
            children: [
              if (isCurrentLine && !isEditable)
                Positioned(
                  left: line.isResult ? maxWidth - textWidth : 0,
                  width: textWidth,
                  top: 0,
                  bottom: 0,
                  child: Container(color: Colors.blue.withAlpha(64)),
                ),

              Align(
                alignment: line.isResult
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  line.text,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: fontSize,
                    height: lineHeight,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              if (isCurrentLine && isEditable && buffer.cursorVisible)
                Positioned(
                  left: _cursorX(line, maxWidth),
                  top: 0,
                  child: Container(
                    width: _measureTextWidth("0"),
                    height: fontSize * lineHeight,
                    color: Colors.black.withAlpha(128),
                  ),
                ),
            ],
          ),
        ),
      );

      if (line.isResult) {
        widgets.add(const Divider(height: 4, thickness: 1));
      }
    }

    return widgets;
  }

  double _cursorX(CalcLine line, double maxWidth) {
    final text = line.text;
    final col = buffer.cursorCol;

    final beforeCursor = col <= text.length ? text.substring(0, col) : text;

    final textWidth = _measureTextWidth(text);
    final cursorOffset = _measureTextWidth(beforeCursor);

    if (line.isResult) {
      return maxWidth - textWidth + cursorOffset;
    } else {
      return cursorOffset;
    }
  }

  double _measureTextWidth(String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontFamily: 'Courier', fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return painter.width;
  }
}
