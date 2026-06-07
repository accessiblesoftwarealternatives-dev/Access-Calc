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

  void onButtonPressed(ButtonAction action) {
    resetCursorTimer();
    action.execute(buffer);
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
  void Function(ButtonAction) onPressed,
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

Widget _buildKeypad(
  CalculatorTheme theme,
  void Function(ButtonAction) onPressed,
) {
  return Padding(
    padding: const EdgeInsets.all(6),
    child: Column(
      children: [
        _buildRow(
          [
            CalcButtonData("Y=", ButtonType.operator, ButtonAction.yEquals),
            CalcButtonData("WINDOW", ButtonType.operator, ButtonAction.window),
            CalcButtonData("ZOOM", ButtonType.operator, ButtonAction.zoom),
            CalcButtonData("TRACE", ButtonType.operator, ButtonAction.trace),
            CalcButtonData("GRAPH", ButtonType.operator, ButtonAction.graph),
          ],
          theme,
          onPressed,
        ),

        _buildDPadRow(theme, onPressed),

        _buildRow(
          [
            CalcButtonData("MATH", ButtonType.function, ButtonAction.math),
            CalcButtonData("APPS", ButtonType.function, ButtonAction.apps),
            CalcButtonData("PRGM", ButtonType.function, ButtonAction.prgm),
            CalcButtonData("VARS", ButtonType.function, ButtonAction.vars),
            CalcButtonData("CLEAR", ButtonType.function, ButtonAction.clear),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData(
              "𝓍⁻¹",
              ButtonType.function,
              ButtonAction.reciprocal,
            ),
            CalcButtonData("SIN", ButtonType.function, ButtonAction.sin),
            CalcButtonData("COS", ButtonType.function, ButtonAction.cos),
            CalcButtonData("TAN", ButtonType.function, ButtonAction.tan),
            CalcButtonData("^", ButtonType.function, ButtonAction.power),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("𝓍²", ButtonType.function, ButtonAction.square),
            CalcButtonData(",", ButtonType.function, ButtonAction.comma),
            CalcButtonData("(", ButtonType.function, ButtonAction.leftParen),
            CalcButtonData(")", ButtonType.function, ButtonAction.rightParen),
            CalcButtonData("÷", ButtonType.operator, ButtonAction.divide),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("LOG", ButtonType.function, ButtonAction.log),
            CalcButtonData("7", ButtonType.number, ButtonAction.digit7),
            CalcButtonData("8", ButtonType.number, ButtonAction.digit8),
            CalcButtonData("9", ButtonType.number, ButtonAction.digit9),
            CalcButtonData("X", ButtonType.operator, ButtonAction.multiply),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("LN", ButtonType.function, ButtonAction.ln),
            CalcButtonData("4", ButtonType.number, ButtonAction.digit4),
            CalcButtonData("5", ButtonType.number, ButtonAction.digit5),
            CalcButtonData("6", ButtonType.number, ButtonAction.digit6),
            CalcButtonData("―", ButtonType.operator, ButtonAction.subtract),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("STO>", ButtonType.function, ButtonAction.store),
            CalcButtonData("1", ButtonType.number, ButtonAction.digit1),
            CalcButtonData("2", ButtonType.number, ButtonAction.digit2),
            CalcButtonData("3", ButtonType.number, ButtonAction.digit3),
            CalcButtonData("+", ButtonType.operator, ButtonAction.add),
          ],
          theme,
          onPressed,
        ),

        _buildRow(
          [
            CalcButtonData("ON", ButtonType.function, ButtonAction.on),
            CalcButtonData("0", ButtonType.number, ButtonAction.digit0),
            CalcButtonData("·", ButtonType.number, ButtonAction.decimal),
            CalcButtonData("(-)", ButtonType.number, ButtonAction.negative),
            CalcButtonData("ENTER", ButtonType.operator, ButtonAction.enter),
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
  void Function(ButtonAction) onPressed,
) {
  return Row(
    children: buttons.map((data) {
      return Expanded(child: _buildButton(data, theme, onPressed));
    }).toList(),
  );
}

Widget _buildDPadRow(
  CalculatorTheme theme,
  void Function(ButtonAction) onPressed,
) {
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
                    CalcButtonData(
                      "2ND",
                      ButtonType.second,
                      ButtonAction.second,
                    ),
                    CalcButtonData(
                      "MODE",
                      ButtonType.function,
                      ButtonAction.mode,
                    ),
                    CalcButtonData(
                      "DEL",
                      ButtonType.function,
                      ButtonAction.delete,
                    ),
                  ],
                  theme,
                  onPressed,
                ),
              ),

              Expanded(
                child: _buildRow(
                  [
                    CalcButtonData(
                      "ALPHA",
                      ButtonType.alpha,
                      ButtonAction.alpha,
                    ),
                    CalcButtonData(
                      "X,T,Ø,n",
                      ButtonType.function,
                      ButtonAction.xtheta,
                    ),
                    CalcButtonData(
                      "STAT",
                      ButtonType.function,
                      ButtonAction.stat,
                    ),
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
  void Function(ButtonAction) onPressed,
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
        onPressed(data.action);
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(data.label, style: TextStyle(color: style.textColor)),
      ),
    ),
  );
}

Widget _buildDPad(
  CalculatorTheme theme,
  void Function(ButtonAction) onPressed,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxWidth;

      final buttonSize = size * 0.35;

      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _arrowButton(
              ButtonAction.up,
              "˄",
              theme,
              buttonSize,
              onPressed,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _arrowButton(
              ButtonAction.down,
              "˅",
              theme,
              buttonSize,
              onPressed,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _arrowButton(
              ButtonAction.left,
              "˂",
              theme,
              buttonSize,
              onPressed,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _arrowButton(
              ButtonAction.right,
              "˃",
              theme,
              buttonSize,
              onPressed,
            ),
          ),
        ],
      );
    },
  );
}

Widget _arrowButton(
  ButtonAction action,
  String label,
  CalculatorTheme theme,
  double size,
  void Function(ButtonAction) onPressed,
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
        onPressed(action);
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
