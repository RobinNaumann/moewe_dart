import 'package:flutter/material.dart';

class MoeweTheme {
  final Color colorAccent;
  final Color colorOnAccent;
  final bool darkTheme;

  /// Sizes within the moewe theme are based on the rem unit.
  /// This is the base size for the rem unit in terms of logical pixels.
  final double remSize;
  final double borderWidth;
  final double borderRadius;

  /// The offset of the back button in the feedback page. This is useful
  /// when using a custom window decoration such as those of macos_ui.
  final double backButtonOffset;

  const MoeweTheme(
      {this.colorAccent = const Color(0xFF21488A),
      this.colorOnAccent = Colors.white,
      this.darkTheme = false,
      this.remSize = 16.0,
      this.borderWidth = 1,
      this.borderRadius = 8,
      this.backButtonOffset = 0});
}
