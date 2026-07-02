abstract class CalcToken {
  String get displayText;
}

class NumberToken extends CalcToken {
  final String value;

  NumberToken(this.value);

  @override
  String get displayText => value;
}

enum OperatorType { add, subtract, multiply, divide, power }

class OperatorToken extends CalcToken {
  final OperatorType type;

  OperatorToken(this.type);

  @override
  String get displayText {
    switch (type) {
      case OperatorType.add:
        return '+';
      case OperatorType.subtract:
        return '―';
      case OperatorType.multiply:
        return 'X';
      case OperatorType.divide:
        return '÷';
      case OperatorType.power:
        return '^';
    }
  }
}

enum FunctionType { sin, cos, tan, log, ln }

class FunctionToken extends CalcToken {
  final FunctionType type;

  FunctionToken(this.type);

  @override
  String get displayText {
    switch (type) {
      case FunctionType.sin:
        return 'sin(';
      case FunctionType.cos:
        return 'cos(';
      case FunctionType.tan:
        return 'tan(';
      case FunctionType.log:
        return 'log(';
      case FunctionType.ln:
        return 'ln(';
    }
  }
}

class LeftParenToken extends CalcToken {
  @override
  String get displayText => '(';
}

class RightParenToken extends CalcToken {
  @override
  String get displayText => ')';
}
