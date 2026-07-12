import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/button_mode.dart';
import 'package:graphing_calculator/models/calc_button.dart';
import 'package:graphing_calculator/models/dpad.dart';
import 'package:graphing_calculator/screens/calculator_display.dart';

import '../models/calculator_buffer.dart';
import '../models/button_type.dart';
import '../models/calc_button_data.dart';
import '../models/calculator_theme.dart';
import '../themes/ti_themes.dart';

class CalculatorKeypad extends StatefulWidget {
  const CalculatorKeypad({super.key});

  @override
  State<CalculatorKeypad> createState() => _CalculatorKeypadState();
}

class _CalculatorKeypadState extends State<CalculatorKeypad> {
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
      Expanded(
        flex: 5,
        child: AnimatedBuilder(
          animation: buffer,
          builder: (context, _) {
            return _buildKeypad(theme, buffer.mode, onPressed, unit);
          },
        ),
      ),
    ],
  );
}

Widget _buildKeypad(
  CalculatorTheme theme,
  ButtonMode mode,
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
                    secondFunction: const CalcButtonFunction(
                      "STAT PLOT",
                      ButtonType.second,
                      ButtonAction.statPlot,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "F1",
                      ButtonType.alpha,
                      ButtonAction.f1,
                    ),
                  ),
                  CalcButtonData(
                    "WINDOW",
                    ButtonType.operator,
                    ButtonAction.window,
                    secondFunction: const CalcButtonFunction(
                      "TBLSET",
                      ButtonType.second,
                      ButtonAction.tblSet,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "F2",
                      ButtonType.alpha,
                      ButtonAction.f2,
                    ),
                  ),
                  CalcButtonData(
                    "ZOOM",
                    ButtonType.operator,
                    ButtonAction.zoom,
                    secondFunction: const CalcButtonFunction(
                      "FORMAT",
                      ButtonType.second,
                      ButtonAction.format,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "F3",
                      ButtonType.alpha,
                      ButtonAction.f3,
                    ),
                  ),
                  CalcButtonData(
                    "TRACE",
                    ButtonType.operator,
                    ButtonAction.trace,
                    secondFunction: const CalcButtonFunction(
                      "CALC",
                      ButtonType.second,
                      ButtonAction.calcMenu,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "F4",
                      ButtonType.alpha,
                      ButtonAction.f4,
                    ),
                  ),
                  CalcButtonData(
                    "GRAPH",
                    ButtonType.operator,
                    ButtonAction.graph,
                    secondFunction: const CalcButtonFunction(
                      "TABLE",
                      ButtonType.second,
                      ButtonAction.table,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "F5",
                      ButtonType.alpha,
                      ButtonAction.f5,
                    ),
                  ),
                ],
                theme,
                mode,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              flex: 2,
              child: _buildDPadRow(theme, mode, onPressed, unit, columnWidth),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "MATH",
                    ButtonType.function,
                    ButtonAction.math,
                    secondFunction: const CalcButtonFunction(
                      "TEST",
                      ButtonType.second,
                      ButtonAction.test,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "A",
                      ButtonType.alpha,
                      ButtonAction.letterA,
                    ),
                  ),
                  CalcButtonData(
                    "APPS",
                    ButtonType.function,
                    ButtonAction.apps,
                    secondFunction: const CalcButtonFunction(
                      "ANGLE",
                      ButtonType.second,
                      ButtonAction.angle,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "B",
                      ButtonType.alpha,
                      ButtonAction.letterB,
                    ),
                  ),
                  CalcButtonData(
                    "PRGM",
                    ButtonType.function,
                    ButtonAction.prgm,
                    secondFunction: const CalcButtonFunction(
                      "DRAW",
                      ButtonType.second,
                      ButtonAction.draw,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "C",
                      ButtonType.alpha,
                      ButtonAction.letterC,
                    ),
                  ),
                  CalcButtonData(
                    "VARS",
                    ButtonType.function,
                    ButtonAction.vars,
                    secondFunction: const CalcButtonFunction(
                      "DISTR",
                      ButtonType.second,
                      ButtonAction.distr,
                    ),
                  ),
                  CalcButtonData(
                    "CLEAR",
                    ButtonType.function,
                    ButtonAction.clear,
                  ),
                ],
                theme,
                mode,
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
                    secondFunction: const CalcButtonFunction(
                      "MATRIX",
                      ButtonType.second,
                      ButtonAction.matrix,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "D",
                      ButtonType.alpha,
                      ButtonAction.letterD,
                    ),
                  ),
                  CalcButtonData(
                    "SIN",
                    ButtonType.function,
                    ButtonAction.sin,
                    secondFunction: const CalcButtonFunction(
                      "SIN⁻¹",
                      ButtonType.second,
                      ButtonAction.asin,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "E",
                      ButtonType.alpha,
                      ButtonAction.letterE,
                    ),
                  ),
                  CalcButtonData(
                    "COS",
                    ButtonType.function,
                    ButtonAction.cos,
                    secondFunction: const CalcButtonFunction(
                      "COS⁻¹",
                      ButtonType.second,
                      ButtonAction.acos,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "F",
                      ButtonType.alpha,
                      ButtonAction.letterF,
                    ),
                  ),
                  CalcButtonData(
                    "TAN",
                    ButtonType.function,
                    ButtonAction.tan,
                    secondFunction: const CalcButtonFunction(
                      "TAN⁻¹",
                      ButtonType.second,
                      ButtonAction.atan,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "G",
                      ButtonType.alpha,
                      ButtonAction.letterG,
                    ),
                  ),
                  CalcButtonData(
                    "^",
                    ButtonType.function,
                    ButtonAction.power,
                    secondFunction: const CalcButtonFunction(
                      "π",
                      ButtonType.second,
                      ButtonAction.piConst,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "H",
                      ButtonType.alpha,
                      ButtonAction.letterH,
                    ),
                  ),
                ],
                theme,
                mode,
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
                    secondFunction: const CalcButtonFunction(
                      "√",
                      ButtonType.second,
                      ButtonAction.squareRoot,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "I",
                      ButtonType.alpha,
                      ButtonAction.letterI,
                    ),
                  ),
                  CalcButtonData(
                    ",",
                    ButtonType.function,
                    ButtonAction.comma,
                    secondFunction: const CalcButtonFunction(
                      "EE",
                      ButtonType.second,
                      ButtonAction.ee,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "J",
                      ButtonType.alpha,
                      ButtonAction.letterJ,
                    ),
                  ),
                  CalcButtonData(
                    "(",
                    ButtonType.function,
                    ButtonAction.leftParen,
                    secondFunction: const CalcButtonFunction(
                      "{",
                      ButtonType.second,
                      ButtonAction.leftBrace,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "K",
                      ButtonType.alpha,
                      ButtonAction.letterK,
                    ),
                  ),
                  CalcButtonData(
                    ")",
                    ButtonType.function,
                    ButtonAction.rightParen,
                    secondFunction: const CalcButtonFunction(
                      "}",
                      ButtonType.second,
                      ButtonAction.rightBrace,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "L",
                      ButtonType.alpha,
                      ButtonAction.letterL,
                    ),
                  ),
                  CalcButtonData(
                    "÷",
                    ButtonType.operator,
                    ButtonAction.divide,
                    secondFunction: const CalcButtonFunction(
                      "e",
                      ButtonType.second,
                      ButtonAction.eConst,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "M",
                      ButtonType.alpha,
                      ButtonAction.letterM,
                    ),
                  ),
                ],
                theme,
                mode,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "LOG",
                    ButtonType.function,
                    ButtonAction.log,
                    secondFunction: const CalcButtonFunction(
                      "10ˣ",
                      ButtonType.second,
                      ButtonAction.tenToX,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "N",
                      ButtonType.alpha,
                      ButtonAction.letterN,
                    ),
                  ),
                  CalcButtonData(
                    "7",
                    ButtonType.number,
                    ButtonAction.digit7,
                    secondFunction: const CalcButtonFunction(
                      "u",
                      ButtonType.second,
                      ButtonAction.letteru,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "O",
                      ButtonType.alpha,
                      ButtonAction.letterO,
                    ),
                  ),
                  CalcButtonData(
                    "8",
                    ButtonType.number,
                    ButtonAction.digit8,
                    secondFunction: const CalcButtonFunction(
                      "v",
                      ButtonType.second,
                      ButtonAction.letterv,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "P",
                      ButtonType.alpha,
                      ButtonAction.letterP,
                    ),
                  ),
                  CalcButtonData(
                    "9",
                    ButtonType.number,
                    ButtonAction.digit9,
                    secondFunction: const CalcButtonFunction(
                      "w",
                      ButtonType.second,
                      ButtonAction.letterw,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "Q",
                      ButtonType.alpha,
                      ButtonAction.letterQ,
                    ),
                  ),
                  CalcButtonData(
                    "X",
                    ButtonType.operator,
                    ButtonAction.multiply,
                    secondFunction: const CalcButtonFunction(
                      "[",
                      ButtonType.second,
                      ButtonAction.leftBracket,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "R",
                      ButtonType.alpha,
                      ButtonAction.letterR,
                    ),
                  ),
                ],
                theme,
                mode,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "LN",
                    ButtonType.function,
                    ButtonAction.ln,
                    secondFunction: const CalcButtonFunction(
                      "eˣ",
                      ButtonType.second,
                      ButtonAction.eToX,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "S",
                      ButtonType.alpha,
                      ButtonAction.letterS,
                    ),
                  ),
                  CalcButtonData(
                    "4",
                    ButtonType.number,
                    ButtonAction.digit4,
                    secondFunction: const CalcButtonFunction(
                      "L4",
                      ButtonType.second,
                      ButtonAction.l4,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "T",
                      ButtonType.alpha,
                      ButtonAction.letterT,
                    ),
                  ),
                  CalcButtonData(
                    "5",
                    ButtonType.number,
                    ButtonAction.digit5,
                    secondFunction: const CalcButtonFunction(
                      "L5",
                      ButtonType.second,
                      ButtonAction.l5,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "U",
                      ButtonType.alpha,
                      ButtonAction.letterU,
                    ),
                  ),
                  CalcButtonData(
                    "6",
                    ButtonType.number,
                    ButtonAction.digit6,
                    secondFunction: const CalcButtonFunction(
                      "L6",
                      ButtonType.second,
                      ButtonAction.l6,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "V",
                      ButtonType.alpha,
                      ButtonAction.letterV,
                    ),
                  ),
                  CalcButtonData(
                    "―",
                    ButtonType.operator,
                    ButtonAction.subtract,
                    secondFunction: const CalcButtonFunction(
                      "]",
                      ButtonType.second,
                      ButtonAction.rightBracket,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "W",
                      ButtonType.alpha,
                      ButtonAction.letterW,
                    ),
                  ),
                ],
                theme,
                mode,
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
                    secondFunction: const CalcButtonFunction(
                      "RCL",
                      ButtonType.second,
                      ButtonAction.rcl,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "X",
                      ButtonType.alpha,
                      ButtonAction.letterX,
                    ),
                  ),
                  CalcButtonData(
                    "1",
                    ButtonType.number,
                    ButtonAction.digit1,
                    secondFunction: const CalcButtonFunction(
                      "L1",
                      ButtonType.second,
                      ButtonAction.l1,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "Y",
                      ButtonType.alpha,
                      ButtonAction.letterY,
                    ),
                  ),
                  CalcButtonData(
                    "2",
                    ButtonType.number,
                    ButtonAction.digit2,
                    secondFunction: const CalcButtonFunction(
                      "L2",
                      ButtonType.second,
                      ButtonAction.l2,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "Z",
                      ButtonType.alpha,
                      ButtonAction.letterZ,
                    ),
                  ),
                  CalcButtonData(
                    "3",
                    ButtonType.number,
                    ButtonAction.digit3,
                    secondFunction: const CalcButtonFunction(
                      "L3",
                      ButtonType.second,
                      ButtonAction.l3,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "θ",
                      ButtonType.alpha,
                      ButtonAction.theta,
                    ),
                  ),
                  CalcButtonData(
                    "+",
                    ButtonType.operator,
                    ButtonAction.add,
                    secondFunction: const CalcButtonFunction(
                      "MEM",
                      ButtonType.second,
                      ButtonAction.mem,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "\"",
                      ButtonType.alpha,
                      ButtonAction.quotation,
                    ),
                  ),
                ],
                theme,
                mode,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "ON",
                    ButtonType.function,
                    ButtonAction.on,
                    secondFunction: const CalcButtonFunction(
                      "OFF",
                      ButtonType.second,
                      ButtonAction.off,
                    ),
                  ),
                  CalcButtonData(
                    "0",
                    ButtonType.number,
                    ButtonAction.digit0,
                    secondFunction: const CalcButtonFunction(
                      "CATALOG",
                      ButtonType.second,
                      ButtonAction.catalog,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "⎵",
                      ButtonType.alpha,
                      ButtonAction.space,
                    ),
                  ),
                  CalcButtonData(
                    "·",
                    ButtonType.number,
                    ButtonAction.decimal,
                    secondFunction: const CalcButtonFunction(
                      "i",
                      ButtonType.second,
                      ButtonAction.imaginaryUnit,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      ":",
                      ButtonType.alpha,
                      ButtonAction.colon,
                    ),
                  ),
                  CalcButtonData(
                    "(-)",
                    ButtonType.number,
                    ButtonAction.negative,
                    secondFunction: const CalcButtonFunction(
                      "ANS",
                      ButtonType.second,
                      ButtonAction.ans,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "?",
                      ButtonType.alpha,
                      ButtonAction.questionMark,
                    ),
                  ),
                  CalcButtonData(
                    "ENTER",
                    ButtonType.operator,
                    ButtonAction.enter,
                    secondFunction: const CalcButtonFunction(
                      "ENTRY",
                      ButtonType.second,
                      ButtonAction.entry,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "SOLVE",
                      ButtonType.alpha,
                      ButtonAction.solve,
                    ),
                  ),
                ],
                theme,
                mode,
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
  ButtonMode mode,
  void Function(ButtonAction) onPressed,
  double unit,
) {
  return Row(
    children: buttons.map((data) {
      return Expanded(
        child: CalcButton(
          data: data,
          theme: theme,
          mode: mode,
          onPressed: onPressed,
          unit: unit,
        ),
      );
    }).toList(),
  );
}

Widget _buildDPadRow(
  CalculatorTheme theme,
  ButtonMode mode,
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
                    secondFunction: const CalcButtonFunction(
                      "QUIT",
                      ButtonType.second,
                      ButtonAction.quit,
                    ),
                  ),
                  CalcButtonData(
                    "DEL",
                    ButtonType.function,
                    ButtonAction.delete,
                    secondFunction: const CalcButtonFunction(
                      "INS",
                      ButtonType.second,
                      ButtonAction.ins,
                    ),
                  ),
                ],
                theme,
                mode,
                onPressed,
                unit,
              ),
            ),

            Expanded(
              child: _buildRow(
                [
                  CalcButtonData(
                    "ALPHA",
                    ButtonType.alpha,
                    ButtonAction.alpha,
                    secondFunction: const CalcButtonFunction(
                      "A-LOCK",
                      ButtonType.second,
                      ButtonAction.alpha,
                    ),
                  ),
                  CalcButtonData(
                    "X,T,Ø,n",
                    ButtonType.function,
                    ButtonAction.xtheta,
                    secondFunction: const CalcButtonFunction(
                      "LINK",
                      ButtonType.second,
                      ButtonAction.link,
                    ),
                    alphaFunction: const CalcButtonFunction(
                      "÷",
                      ButtonType.alpha,
                      ButtonAction.fraction,
                    ),
                  ),
                  CalcButtonData(
                    "STAT",
                    ButtonType.function,
                    ButtonAction.stat,
                    secondFunction: const CalcButtonFunction(
                      "LIST",
                      ButtonType.second,
                      ButtonAction.list,
                    ),
                  ),
                ],
                theme,
                mode,
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
