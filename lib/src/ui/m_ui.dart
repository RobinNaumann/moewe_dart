import 'package:flutter/material.dart';

class MoeweTheme {
  final Color colorAccent;
  final Color colorOnAccent;
  final bool darkTheme;
  final double remSize;
  final double borderWidth;
  final double borderRadius;

  const MoeweTheme(
      {this.colorAccent = const Color(0xFF21488A),
      this.colorOnAccent = Colors.white,
      this.darkTheme = false,
      this.remSize = 16.0,
      this.borderWidth = 1,
      this.borderRadius = 8});
}
