import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/calc_button_data.dart';
import 'package:graphing_calculator/models/calculator_theme.dart';

class CalcButton extends StatefulWidget {
  final CalcButtonData data;
  final CalculatorTheme theme;
  final void Function(ButtonAction) onPressed;
  final double unit;

  const CalcButton({
    super.key,
    required this.data,
    required this.theme,
    required this.onPressed,
    required this.unit,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.theme.getStyle(widget.data.type);

    return Padding(
      padding: EdgeInsets.all(widget.unit * 0.45),
      child: Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.93 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _pressed
                  ? Color.alphaBlend(
                      Colors.black.withValues(alpha: 0.18),
                      style.backgroundColor,
                    )
                  : style.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.unit * 0.6,
                vertical: widget.unit * 0.9,
              ),
              elevation: _pressed ? 1 : 3,
            ),
            onPressed: () => widget.onPressed(widget.data.action),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.data.label,
                style: TextStyle(color: style.textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
