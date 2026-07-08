import 'package:flutter/material.dart';
import 'package:graphing_calculator/models/calc_button_data.dart';
import 'package:graphing_calculator/models/calculator_theme.dart';

Widget buildDPad(CalculatorTheme theme, void Function(ButtonAction) onPressed) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.maxWidth;
      final buttonSize = size * 0.32;

      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.alphaBlend(
                Colors.black.withValues(alpha: 0.15),
                theme.backgroundColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.12),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _arrowButton(
              ButtonAction.up,
              Icons.keyboard_arrow_up,
              theme,
              buttonSize,
              onPressed,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _arrowButton(
              ButtonAction.down,
              Icons.keyboard_arrow_down,
              theme,
              buttonSize,
              onPressed,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _arrowButton(
              ButtonAction.left,
              Icons.keyboard_arrow_left,
              theme,
              buttonSize,
              onPressed,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _arrowButton(
              ButtonAction.right,
              Icons.keyboard_arrow_right,
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
  IconData icon,
  CalculatorTheme theme,
  double size,
  void Function(ButtonAction) onPressed,
) {
  return _ArrowButton(
    action: action,
    icon: icon,
    theme: theme,
    size: size,
    onPressed: onPressed,
  );
}

class _ArrowButton extends StatefulWidget {
  final ButtonAction action;
  final IconData icon;
  final CalculatorTheme theme;
  final double size;
  final void Function(ButtonAction) onPressed;

  const _ArrowButton({
    required this.action,
    required this.icon,
    required this.theme,
    required this.size,
    required this.onPressed,
  });

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _pressed
                  ? Color.alphaBlend(
                      Colors.black.withValues(alpha: 0.18),
                      widget.theme.operatorStyle.backgroundColor,
                    )
                  : widget.theme.operatorStyle.backgroundColor,
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: _pressed ? 0 : 2,
            ),
            onPressed: () => widget.onPressed(widget.action),
            child: Icon(
              widget.icon,
              color: widget.theme.operatorStyle.textColor,
              size: widget.size * 0.55,
            ),
          ),
        ),
      ),
    );
  }
}
