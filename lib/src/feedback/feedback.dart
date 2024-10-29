import 'package:flutter/material.dart';
import 'package:moewe/moewe.dart';

export '../ui/p_feedback.dart';

/// navigates to the feedback page (using the Flutter Navigator)
/// and allows the user to send feedback.
/// For i18n, you can pass a [labels] object.
/// For theming, you can pass a [theme] object. This also allows you to
/// adapt to dark mode.
@Deprecated('Use MoeweFeedbackPage.show() instead')
void showFeedbackPage(BuildContext context,
    {MoeweTheme theme = const MoeweTheme(),
    FeedbackLabels labels = const FeedbackLabels()}) {
  MoeweFeedbackPage.show(
    context,
    theme: theme,
    labels: labels,
  );
}
