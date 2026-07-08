import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/calc_button.dart';
import 'package:graphing_calculator/models/dpad.dart';
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

  @override
  void dispose() {
    buffer.dispose();
    super.dispose();
  }

  void onButtonPressed(ButtonAction action) {
    action.execute(buffer);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ti84Theme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double unit = constraints.maxWidth / 100;
            return _buildContent(theme, buffer, onButtonPressed, unit);
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
  double unit,
) {
  return Column(
    children: [
      Expanded(
        flex: 2,
        child: CalculatorDisplay(theme: theme, buffer: buffer),
      ),
      Expanded(flex: 5, child: _buildKeypad(theme, onPressed, unit)),
    ],
  );
}

Widget _buildKeypad(
  CalculatorTheme theme,
  void Function(ButtonAction) onPressed,
  double unit,
) {
  return Padding(
    padding: EdgeInsets.all(unit * 1.1),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final double columnWidth = constraints.maxWidth / 5;

        return Column(
          children: [
            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "Y=",
                    ButtonType.operator,
                    ButtonAction.yEquals,
                  ),
                  CalcButtonData(
                    "WINDOW",
                    ButtonType.operator,
                    ButtonAction.window,
                  ),
                  CalcButtonData(
                    "ZOOM",
                    ButtonType.operator,
                    ButtonAction.zoom,
                  ),
                  CalcButtonData(
                    "TRACE",
                    ButtonType.operator,
                    ButtonAction.trace,
                  ),
                  CalcButtonData(
                    "GRAPH",
                    ButtonType.operator,
                    ButtonAction.graph,
                  ),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              flex: 2,
              child: _buildDPadRow(theme, onPressed, unit, columnWidth),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "MATH",
                    ButtonType.function,
                    ButtonAction.math,
                  ),
                  CalcButtonData(
                    "APPS",
                    ButtonType.function,
                    ButtonAction.apps,
                  ),
                  CalcButtonData(
                    "PRGM",
                    ButtonType.function,
                    ButtonAction.prgm,
                  ),
                  CalcButtonData(
                    "VARS",
                    ButtonType.function,
                    ButtonAction.vars,
                  ),
                  CalcButtonData(
                    "CLEAR",
                    ButtonType.function,
                    ButtonAction.clear,
                  ),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
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
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "𝓍²",
                    ButtonType.function,
                    ButtonAction.square,
                  ),
                  CalcButtonData(",", ButtonType.function, ButtonAction.comma),
                  CalcButtonData(
                    "(",
                    ButtonType.function,
                    ButtonAction.leftParen,
                  ),
                  CalcButtonData(
                    ")",
                    ButtonType.function,
                    ButtonAction.rightParen,
                  ),
                  CalcButtonData("÷", ButtonType.operator, ButtonAction.divide),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData("LOG", ButtonType.function, ButtonAction.log),
                  CalcButtonData("7", ButtonType.number, ButtonAction.digit7),
                  CalcButtonData("8", ButtonType.number, ButtonAction.digit8),
                  CalcButtonData("9", ButtonType.number, ButtonAction.digit9),
                  CalcButtonData(
                    "X",
                    ButtonType.operator,
                    ButtonAction.multiply,
                  ),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData("LN", ButtonType.function, ButtonAction.ln),
                  CalcButtonData("4", ButtonType.number, ButtonAction.digit4),
                  CalcButtonData("5", ButtonType.number, ButtonAction.digit5),
                  CalcButtonData("6", ButtonType.number, ButtonAction.digit6),
                  CalcButtonData(
                    "―",
                    ButtonType.operator,
                    ButtonAction.subtract,
                  ),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "STO>",
                    ButtonType.function,
                    ButtonAction.store,
                  ),
                  CalcButtonData("1", ButtonType.number, ButtonAction.digit1),
                  CalcButtonData("2", ButtonType.number, ButtonAction.digit2),
                  CalcButtonData("3", ButtonType.number, ButtonAction.digit3),
                  CalcButtonData("+", ButtonType.operator, ButtonAction.add),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData("ON", ButtonType.function, ButtonAction.on),
                  CalcButtonData("0", ButtonType.number, ButtonAction.digit0),
                  CalcButtonData("·", ButtonType.number, ButtonAction.decimal),
                  CalcButtonData(
                    "(-)",
                    ButtonType.number,
                    ButtonAction.negative,
                  ),
                  CalcButtonData(
                    "ENTER",
                    ButtonType.operator,
                    ButtonAction.enter,
                  ),
                ],
                theme,
                onPressed,
                unit,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildRow(
  List<CalcButtonData> buttons,
  CalculatorTheme theme,
  void Function(ButtonAction) onPressed,
  double unit,
) {
  return Row(
    children: buttons.map((data) {
      return Expanded(
        child: CalcButton(
          data: data,
          theme: theme,
          onPressed: onPressed,
          unit: unit,
        ),
      );
    }).toList(),
  );
}

Widget _buildDPadRow(
  CalculatorTheme theme,
  void Function(ButtonAction) onPressed,
  double unit,
  double columnWidth,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(
        width: columnWidth * 3,
        child: Column(
          children: [
            Expanded(
              child: _buildRow(
                [
                  CalcButtonData("2ND", ButtonType.second, ButtonAction.second),
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
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData("ALPHA", ButtonType.alpha, ButtonAction.alpha),
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
                unit,
              ),
            ),
          ],
        ),
      ),

      Expanded(
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: buildDPad(theme, onPressed),
          ),
        ),
      ),
    ],
  );
}
