import 'package:flutter/material.dart';

class CalculatorBuffer extends ChangeNotifier {
  List<CalcLine> lines = [CalcLine('')];
  int cursorRow = 0;
  int cursorCol = 0;
  int scrollOffset = 0;

  final int visibleLineCount;

  bool cursorVisible = true;

  bool overwriteMode = true;

  CalculatorBuffer({this.visibleLineCount = 6});

  void insert(String text) {
    if (!isOnEditableLine) return;

    final line = lines[cursorRow];

    if (overwriteMode && cursorCol < line.text.length) {
      lines[cursorRow] = CalcLine(
        line.text.substring(0, cursorCol) +
            text +
            line.text.substring(cursorCol + 1),
      );
    } else {
      lines[cursorRow] = CalcLine(
        line.text.substring(0, cursorCol) +
            text +
            line.text.substring(cursorCol),
      );
    }

    cursorCol += text.length;
    notifyListeners();
  }

  void moveLeft() {
    if (cursorCol > 0) {
      cursorCol--;
      notifyListeners();
    }
  }

  void moveRight() {
    if (cursorCol < lines[cursorRow].text.length) {
      cursorCol++;
      notifyListeners();
    }
  }

  void moveUp() {
    if (cursorRow > 0) {
      cursorRow--;
      cursorCol = cursorCol.clamp(0, lines[cursorRow].text.length);
      _updateScroll();
      notifyListeners();
    }
  }

  void moveDown() {
    if (cursorRow < lines.length - 1) {
      cursorRow++;
      cursorCol = cursorCol.clamp(0, lines[cursorRow].text.length);
      _updateScroll();
      notifyListeners();
    }
  }

  void delete() {
    if (!isOnEditableLine) {
      _deleteEntryBlock();
      return;
    }

    final line = lines[cursorRow];

    if (cursorCol >= line.text.length) return;

    lines[cursorRow] = CalcLine(
      line.text.substring(0, cursorCol) + line.text.substring(cursorCol + 1),
    );

    notifyListeners();
  }

  void _deleteEntryBlock() {
    if (cursorRow <= 0) return;

    int start = cursorRow;

    if (lines[cursorRow].isResult) {
      start = cursorRow - 1;
    }

    if (start < 0 || start + 1 >= lines.length) return;

    lines.removeAt(start);
    lines.removeAt(start);

    cursorRow = lines.length - 1;
    cursorCol = lines[cursorRow].text.length;

    _updateScroll();
    notifyListeners();
  }

  void enter() {
    if (!isOnEditableLine) {
      final text = lines[cursorRow].text;

      lines.add(CalcLine(text));
      cursorRow = lines.length - 1;
      cursorCol = text.length;

      _updateScroll();
      notifyListeners();
      return;
    }

    final expression = lines[cursorRow].text;

    if (expression.trim().isEmpty && lines.length >= 2) {
      for (int i = lines.length - 2; i >= 0; i--) {
        if (!lines[i].isResult && lines[i].text.trim().isNotEmpty) {
          final prevExpr = lines[i].text;
          final result = _evaluate(prevExpr);

          lines.add(CalcLine(prevExpr));
          lines.add(CalcLine(result, isResult: true));
          lines.add(CalcLine(''));

          cursorRow = lines.length - 1;
          cursorCol = 0;

          _updateScroll();
          notifyListeners();
          return;
        }
      }
    }

    final result = _evaluate(expression);

    lines.add(CalcLine(result, isResult: true));
    lines.add(CalcLine(''));

    cursorRow = lines.length - 1;
    cursorCol = 0;

    _updateScroll();
    notifyListeners();
  }

  String _evaluate(String expression) {
    return expression; // temp
  }

  void toggleCursor() {
    cursorVisible = !cursorVisible;
    notifyListeners();
  }

  void showCursor() {
    cursorVisible = true;
    notifyListeners();
  }

  void _updateScroll() {
    if (cursorRow >= scrollOffset + visibleLineCount) {
      scrollOffset = cursorRow - visibleLineCount + 1;
    }

    if (cursorRow < scrollOffset) {
      scrollOffset = cursorRow;
    }
  }

  List<CalcLine> get visibleLines {
    return lines.skip(scrollOffset).take(visibleLineCount).toList();
  }

  bool get isOnEditableLine {
    return cursorRow == lines.length - 1;
  }
}

class CalcLine {
  final String text;
  final bool isResult;

  CalcLine(this.text, {this.isResult = false});
}
