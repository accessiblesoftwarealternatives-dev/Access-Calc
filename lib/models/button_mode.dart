enum ButtonMode { normal, second, alpha, alphaLock }

extension ButtonModeX on ButtonMode {
  bool get isAlpha => this == ButtonMode.alpha || this == ButtonMode.alphaLock;

  bool get isSecond => this == ButtonMode.second;

  bool get isLocked => this == ButtonMode.alphaLock;
}
