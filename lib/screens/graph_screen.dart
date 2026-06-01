import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphing_calculator/screens/calculator_display.dart';

import '../models/calculator_buffer.dart';
import '../models/button_type.dart';
import '../models/calc_button_data.dart';
import '../models/calculator_theme.dart';
import '../themes/ti_themes.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  final CalculatorBuffer buffer = CalculatorBuffer();
  Timer? cursorTimer;

  @override
  void initState() {
    super.initState();

    cursorTimer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => buffer.toggleCursor(),
    );
  }

  @override
  void dispose() {
    cursorTimer?.cancel();
    super.dispose();
  }

  void onButtonPressed(String value) {
    resetCursorTimer();
    switch (value) {
      case "˂":
        buffer.moveLeft();
        break;
      case "˃":
        buffer.moveRight();
        break;
      case "˄":
        buffer.moveUp();
        break;
      case "˅":
        buffer.moveDown();
        break;
      case "DEL":
        buffer.delete();
        break;
      case "ENTER":
        buffer.enter();
        break;
      default:
        buffer.insert(value);
    }
  }

  void resetCursorTimer() {
    cursorTimer?.cancel();

    buffer.showCursor();

    cursorTimer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => buffer.toggleCursor(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ti84Theme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _buildContent(theme, buffer, onButtonPressed);
          },
        ),
      ),
    );
  }
}

Widget _buildContent(
  CalculatorTheme theme,
  CalculatorBuffer buffer,
  void Function(String) onPressed,
) {
  return Column(
    children: [
      Expanded(
        flex: 2,
        child: CalculatorDisplay(theme: theme, buffer: buffer),
      ),
      Expanded(flex: 5, child: _buildKeypad(theme, onPressed)),
    ],
  );
}

Widget _buildKeypad(CalculatorTheme theme, void Function(String) onPressed) {
  return Padding(
    padding: const EdgeInsets.all(6),
    child: Column(
      children: [
        _buildRow(
          [
            CalcButtonData("Y=", ButtonType.operator),
            CalcButtonData("WINDOW", ButtonType.operator),
            CalcButtonData("ZOOM", ButtonType.operator),
            CalcButtonData("TRACE", ButtonType.operator),
            CalcButtonData("GRAPH", ButtonType.operator),
          ],
          theme,
          onPressed,
        ),

        _buildDPadRow(theme, onPressed),

        _buildRow(
          [
            CalcButtonData("MATH", ButtonType.function),
            CalcButtonData("APPS", ButtonType.function),
            CalcButtonData("PRGM", ButtonType.function),
            CalcButtonData("VARS", ButtonType.function),
            CalcButtonData("CLEAR", ButtonType.function),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("𝓍⁻¹", ButtonType.function),
            CalcButtonData("SIN", ButtonType.function),
            CalcButtonData("COS", ButtonType.function),
            CalcButtonData("TAN", ButtonType.function),
            CalcButtonData("^", ButtonType.function),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("𝓍²", ButtonType.function),
            CalcButtonData(",", ButtonType.function),
            CalcButtonData("(", ButtonType.function),
            CalcButtonData(")", ButtonType.function),
            CalcButtonData("÷", ButtonType.operator),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("LOG", ButtonType.function),
            CalcButtonData("7", ButtonType.number),
            CalcButtonData("8", ButtonType.number),
            CalcButtonData("9", ButtonType.number),
            CalcButtonData("X", ButtonType.operator),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("LN", ButtonType.function),
            CalcButtonData("4", ButtonType.number),
            CalcButtonData("5", ButtonType.number),
            CalcButtonData("6", ButtonType.number),
            CalcButtonData("―", ButtonType.operator),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("STO>", ButtonType.function),
            CalcButtonData("1", ButtonType.number),
            CalcButtonData("2", ButtonType.number),
            CalcButtonData("3", ButtonType.number),
            CalcButtonData("+", ButtonType.operator),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("ON", ButtonType.function),
            CalcButtonData("0", ButtonType.number),
            CalcButtonData("·", ButtonType.number),
            CalcButtonData("(-)", ButtonType.number),
            CalcButtonData("ENTER", ButtonType.operator),
          ],
          theme,
          onPressed,
        ),
      ],
    ),
  );
}

Widget _buildRow(
  List<CalcButtonData> buttons,
  CalculatorTheme theme,
  void Function(String) onPressed,
) {
  return Expanded(
    child: Row(
      children: buttons.map((data) {
        return Expanded(child: _buildButton(data, theme, onPressed));
      }).toList(),
    ),
  );
}

Widget _buildDPadRow(CalculatorTheme theme, void Function(String) onPressed) {
  return Expanded(
    flex: 2,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: _buildRow(
                  [
                    CalcButtonData("2ND", ButtonType.second),
                    CalcButtonData("MODE", ButtonType.function),
                    CalcButtonData("DEL", ButtonType.function),
                  ],
                  theme,
                  onPressed,
                ),
              ),

              Expanded(
                child: _buildRow(
                  [
                    CalcButtonData("ALPHA", ButtonType.alpha),
                    CalcButtonData("X,T,Ø,n", ButtonType.function),
                    CalcButtonData("STAT", ButtonType.function),
                  ],
                  theme,
                  onPressed,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          flex: 2,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: _buildDPad(theme, onPressed),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildButton(
  CalcButtonData data,
  CalculatorTheme theme,
  void Function(String) onPressed,
) {
  final style = theme.getStyle(data.type);

  return Padding(
    padding: const EdgeInsets.all(4),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.all(1),
      ),
      onPressed: () {
        onPressed(data.label);
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(data.label, style: TextStyle(color: style.textColor)),
      ),
    ),
  );
}

Widget _buildDPad(CalculatorTheme theme, void Function(String) onPressed) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxWidth;

      final buttonSize = size * 0.35;

      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _arrowButton("˄", theme, buttonSize, onPressed),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _arrowButton("˅", theme, buttonSize, onPressed),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _arrowButton("˂", theme, buttonSize, onPressed),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _arrowButton("˃", theme, buttonSize, onPressed),
          ),
        ],
      );
    },
  );
}

Widget _arrowButton(
  String label,
  CalculatorTheme theme,
  double size,
  void Function(String) onPressed,
) {
  return SizedBox(
    width: size,
    height: size,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.operatorStyle.backgroundColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        onPressed(label);
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(color: theme.operatorStyle.textColor),
        ),
      ),
    ),
  );
}
