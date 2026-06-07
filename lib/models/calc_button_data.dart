import 'package:graphing_calculator/models/calc_token.dart';
import 'package:graphing_calculator/models/calculator_buffer.dart';

import 'button_type.dart';

enum ButtonAction {
  digit0,
  digit1,
  digit2,
  digit3,
  digit4,
  digit5,
  digit6,
  digit7,
  digit8,
  digit9,

  add,
  subtract,
  multiply,
  divide,
  power,

  decimal,
  negative,

  sin,
  cos,
  tan,
  log,
  ln,

  leftParen,
  rightParen,

  comma,

  left,
  right,
  up,
  down,

  delete,
  enter,

  yEquals,
  window,
  zoom,
  trace,
  graph,

  math,
  apps,
  prgm,
  vars,
  clear,

  reciprocal,
  square,

  store,

  second,
  mode,
  alpha,
  xtheta,
  stat,

  on,
}

class CalcButtonData {
  final String label;
  final ButtonType type;
  final ButtonAction action;

  const CalcButtonData(this.label, this.type, this.action);
}

extension ButtonActionExecutor on ButtonAction {
  void execute(CalculatorBuffer buffer) {
    switch (this) {
      case ButtonAction.left:
        buffer.moveLeft();
        break;
      case ButtonAction.right:
        buffer.moveRight();
        break;
      case ButtonAction.up:
        buffer.moveUp();
        break;
      case ButtonAction.down:
        buffer.moveDown();
        break;

      case ButtonAction.delete:
        buffer.delete();
        break;
      case ButtonAction.enter:
        buffer.enter();
        break;

      case ButtonAction.digit0:
        buffer.insertDigit("0");
        break;
      case ButtonAction.digit1:
        buffer.insertDigit("1");
        break;
      case ButtonAction.digit2:
        buffer.insertDigit("2");
        break;
      case ButtonAction.digit3:
        buffer.insertDigit("3");
        break;
      case ButtonAction.digit4:
        buffer.insertDigit("4");
        break;
      case ButtonAction.digit5:
        buffer.insertDigit("5");
        break;
      case ButtonAction.digit6:
        buffer.insertDigit("6");
        break;
      case ButtonAction.digit7:
        buffer.insertDigit("7");
        break;
      case ButtonAction.digit8:
        buffer.insertDigit("8");
        break;
      case ButtonAction.digit9:
        buffer.insertDigit("9");
        break;

      case ButtonAction.add:
        buffer.insertToken(OperatorToken(OperatorType.add));
        break;
      case ButtonAction.subtract:
        buffer.insertToken(OperatorToken(OperatorType.subtract));
        break;
      case ButtonAction.multiply:
        buffer.insertToken(OperatorToken(OperatorType.multiply));
        break;
      case ButtonAction.divide:
        buffer.insertToken(OperatorToken(OperatorType.divide));
        break;
      case ButtonAction.power:
        buffer.insertToken(OperatorToken(OperatorType.power));
        break;

      case ButtonAction.sin:
        buffer.insertToken(FunctionToken(FunctionType.sin));
        break;
      case ButtonAction.cos:
        buffer.insertToken(FunctionToken(FunctionType.cos));
        break;
      case ButtonAction.tan:
        buffer.insertToken(FunctionToken(FunctionType.tan));
        break;
      case ButtonAction.log:
        buffer.insertToken(FunctionToken(FunctionType.log));
        break;
      case ButtonAction.ln:
        buffer.insertToken(FunctionToken(FunctionType.ln));
        break;

      case ButtonAction.leftParen:
        buffer.insertToken(LeftParenToken());
        break;
      case ButtonAction.rightParen:
        buffer.insertToken(RightParenToken());
        break;

      case ButtonAction.comma:
      case ButtonAction.decimal:
      case ButtonAction.negative:
      case ButtonAction.yEquals:
      case ButtonAction.window:
      case ButtonAction.zoom:
      case ButtonAction.trace:
      case ButtonAction.graph:
      case ButtonAction.math:
      case ButtonAction.apps:
      case ButtonAction.prgm:
      case ButtonAction.vars:
      case ButtonAction.clear:
      case ButtonAction.reciprocal:
      case ButtonAction.square:
      case ButtonAction.store:
      case ButtonAction.second:
      case ButtonAction.mode:
      case ButtonAction.alpha:
      case ButtonAction.xtheta:
      case ButtonAction.stat:
      case ButtonAction.on:
        // TODO
        break;
    }
  }
}
