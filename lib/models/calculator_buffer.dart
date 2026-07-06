import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/button_mode.dart';
import 'package:graphing_calculator/models/calc_error.dart';
import 'package:graphing_calculator/models/calc_token.dart';
import 'package:graphing_calculator/models/expression_parser.dart';

class CalculatorBuffer extends ChangeNotifier {
  List<CalcLine> lines = [CalcLine([])];
  int cursorRow = 0;
  int cursorColumn = 0;
  int scrollOffset = 0;

  static const int visibleLineCount = 10;

  Timer? _cursorTimer;

  bool cursorVisible = true;

  ButtonMode mode = ButtonMode.normal;

  CalcError? error;
  List<CalcToken>? _erroredTokens;

  CalculatorBuffer() {
    _startCursorTimer();
  }

  void setMode(ButtonMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void insertToken(CalcToken token) {
    if (!isOnEditableLine) {
      return;
    }

    _resetCursorBlink();

    final line = lines[cursorRow];
    final pos = getCursorPosition();

    if (pos.tokenIndex < line.tokens.length &&
        line.tokens[pos.tokenIndex] is NumberToken &&
        pos.offset > 0 &&
        pos.offset <
            (line.tokens[pos.tokenIndex] as NumberToken).value.length) {
      final number = line.tokens[pos.tokenIndex] as NumberToken;

      final left = number.value.substring(0, pos.offset);
      final right = number.value.substring(pos.offset);

      line.tokens.removeAt(pos.tokenIndex);

      line.tokens.insert(pos.tokenIndex, NumberToken(right));
      line.tokens.insert(pos.tokenIndex, token);
      line.tokens.insert(pos.tokenIndex, NumberToken(left));
    } else {
      line.tokens.insert(pos.tokenIndex, token);
    }

    cursorColumn += token.displayText.length;

    notifyListeners();
  }

  void insertDigit(String digit) {
    if (!isOnEditableLine) {
      return;
    }

    _resetCursorBlink();

    final line = lines[cursorRow];

    final pos = getCursorPosition();

    final prevIndex = pos.tokenIndex - 1;
    final isAfterNumber =
        pos.offset == 0 &&
        prevIndex >= 0 &&
        line.tokens[prevIndex] is NumberToken;

    if (isAfterNumber) {
      final number = line.tokens[prevIndex] as NumberToken;
      line.tokens[prevIndex] = NumberToken(number.value + digit);
    } else if (pos.tokenIndex < line.tokens.length &&
        line.tokens[pos.tokenIndex] is NumberToken) {
      final number = line.tokens[pos.tokenIndex] as NumberToken;

      final text = number.value;

      line.tokens[pos.tokenIndex] = NumberToken(
        text.substring(0, pos.offset) + digit + text.substring(pos.offset),
      );
    } else {
      line.tokens.insert(pos.tokenIndex, NumberToken(digit));
    }

    cursorColumn++;

    notifyListeners();
  }

  void moveLeft() {
    _resetCursorBlink();

    if (!isOnEditableLine) return;

    if (cursorColumn <= 0) return;

    final line = lines[cursorRow];
    final pos = getCursorPosition(column: cursorColumn - 1);
    final token = pos.tokenIndex < line.tokens.length
        ? line.tokens[pos.tokenIndex]
        : null;

    if (_isAtomicBlock(token)) {
      cursorColumn = cursorColumn - 1 - pos.offset;
    } else {
      cursorColumn--;
    }

    notifyListeners();
  }

  void moveRight() {
    _resetCursorBlink();

    if (!isOnEditableLine) return;

    if (cursorColumn >= currentLineLength) return;

    final line = lines[cursorRow];
    final pos = getCursorPosition();
    final token = pos.tokenIndex < line.tokens.length
        ? line.tokens[pos.tokenIndex]
        : null;

    if (_isAtomicBlock(token)) {
      cursorColumn = (cursorColumn - pos.offset) + token!.displayText.length;
    } else {
      cursorColumn++;
    }

    notifyListeners();
  }

  void moveUp() {
    _resetCursorBlink();

    if (cursorRow > 0) {
      cursorRow--;
      if (isOnEditableLine) {
        cursorColumn = cursorColumn.clamp(
          0,
          lines[cursorRow].displayText.length,
        );
      }
      _updateScroll();
      notifyListeners();
    }
  }

  void moveDown() {
    _resetCursorBlink();

    if (cursorRow < lines.length - 1) {
      cursorRow++;
      if (isOnEditableLine) {
        cursorColumn = cursorColumn.clamp(
          0,
          lines[cursorRow].displayText.length,
        );
      }
      _updateScroll();
      notifyListeners();
    }
  }

  CursorPosition getCursorPosition({int? column}) {
    final tokens = lines[cursorRow].tokens;

    int remaining = column ?? cursorColumn;

    for (int i = 0; i < tokens.length; i++) {
      final length = tokens[i].displayText.length;

      if (remaining < length) {
        return CursorPosition(i, remaining);
      }

      remaining -= length;
    }

    return CursorPosition(tokens.length, 0);
  }

  bool _isAtomicBlock(CalcToken? token) {
    return token != null &&
        token is! NumberToken &&
        token.displayText.length > 1;
  }

  int get currentLineLength {
    return lines[cursorRow].tokens.fold(
      0,
      (sum, token) => sum + token.displayText.length,
    );
  }

  void delete() {
    if (!isOnEditableLine) {
      return;
    }

    _resetCursorBlink();

    final line = lines[cursorRow];

    final pos = getCursorPosition();

    if (pos.tokenIndex >= line.tokens.length) {
      return;
    }

    final token = line.tokens[pos.tokenIndex];

    if (token is NumberToken) {
      final text = token.value;

      line.tokens[pos.tokenIndex] = NumberToken(
        text.substring(0, pos.offset) + text.substring(pos.offset + 1),
      );

      if ((line.tokens[pos.tokenIndex] as NumberToken).value.isEmpty) {
        line.tokens.removeAt(pos.tokenIndex);
      }
    } else {
      line.tokens.removeAt(pos.tokenIndex);
    }

    notifyListeners();
  }

  void enter() {
    _resetCursorBlink();

    if (!isOnEditableLine) {
      final sourceLine = lines[cursorRow];
      final editableLine = lines.last;

      editableLine.tokens.addAll(
        sourceLine.tokens.map(
          (t) => t is NumberToken ? NumberToken(t.value) : t,
        ),
      );

      cursorRow = lines.length - 1;
      cursorColumn = editableLine.displayText.length;

      _updateScroll();
      notifyListeners();
      return;
    }

    final expression = lines[cursorRow].displayText;

    if (expression.trim().isEmpty) {
      for (int i = lines.length - 2; i >= 0; i--) {
        if (!lines[i].isResult && lines[i].displayText.trim().isNotEmpty) {
          final tokens = lines[i].tokens;

          lines.removeLast();
          lines.add(CalcLine(List<CalcToken>.from(tokens)));
          _pushResultOrError(tokens);

          cursorRow = lines.length - 1;
          cursorColumn = 0;

          _updateScroll();
          notifyListeners();
          return;
        }
      }
      return;
    }

    _pushResultOrError(lines[cursorRow].tokens);

    cursorRow = lines.length - 1;
    cursorColumn = 0;

    _updateScroll();
    notifyListeners();
  }

  void _pushResultOrError(List<CalcToken> tokens) {
    try {
      final result = _evaluate(tokens);
      lines.add(CalcLine(stringToTokens(result), isResult: true));
      lines.add(CalcLine([]));
    } catch (e) {
      final calcError = e is CalcError ? e : SyntaxError(tokens.length);
      _erroredTokens = List<CalcToken>.from(tokens);
      lines.add(CalcLine(stringToTokens('Error'), isResult: true));
      lines.add(CalcLine([]));
      error = calcError;
    }
  }

  String _evaluate(List<CalcToken> tokens) {
    final parser = ExpressionParser(tokens);
    final result = parser.parseExpression();
    if (result == result.truncateToDouble()) {
      return result.toInt().toString();
    }
    return result.toStringAsFixed(10).replaceAll(RegExp(r'0+$'), '');
  }

  void quitError() {
    if (error == null) return;
    error = null;
    _erroredTokens = null;
    notifyListeners();
  }

  void gotoError() {
    if (error == null) return;

    final tokens = _erroredTokens;
    final tokenIndex = error!.tokenIndex;
    error = null;
    _erroredTokens = null;

    if (tokens != null) {
      final editableLine = lines.last;
      editableLine.tokens.addAll(
        tokens.map((t) => t is NumberToken ? NumberToken(t.value) : t),
      );

      int column = 0;
      for (int i = 0; i < tokens.length && i < tokenIndex; i++) {
        column += tokens[i].displayText.length;
      }
      cursorColumn = column;
    }

    notifyListeners();
  }

  // temp
  List<CalcToken> stringToTokens(String text) {
    return [NumberToken(text)];
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

  void _startCursorTimer() {
    _cursorTimer?.cancel();

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      cursorVisible = !cursorVisible;
      notifyListeners();
    });
  }

  void _resetCursorBlink() {
    cursorVisible = true;

    _startCursorTimer();
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }
}

class CalcLine {
  final List<CalcToken> tokens;
  final bool isResult;

  CalcLine(this.tokens, {this.isResult = false});

  String get displayText => tokens.map((t) => t.displayText).join();
}

class CursorPosition {
  final int tokenIndex;
  final int offset;

  const CursorPosition(this.tokenIndex, this.offset);
}
