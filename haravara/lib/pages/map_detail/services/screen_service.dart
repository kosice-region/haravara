import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart';

String chooseBetterStringToCalculate(String firstText, String secondText) {
  if (firstText.length > secondText.length) {
    return firstText;
  }
  return secondText;
}

Size calculateTextSize(String text, TextStyle style, double maxWidth) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: null,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: maxWidth);

  return textPainter.size;
}

Matrix4 setInitialTransformation(double scale, Offset position) {
  final Matrix4 matrix = Matrix4.identity()
    ..scale(scale)
    ..translate(position.dx, position.dy);
  return matrix;
}
