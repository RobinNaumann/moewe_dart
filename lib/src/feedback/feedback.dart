import 'package:flutter/material.dart';
import 'package:moewe/moewe.dart';
import 'package:moewe/src/ui/m_ui.dart';

export '../ui/p_feedback.dart';

/// navigates to the feedback page (using the Flutter Navigator)
/// and allows the user to send feedback.
/// For i18n, you can pass a [labels] object.
/// For theming, you can pass a [theme] object. This also allows you to
/// adapt to dark mode.
showFeedbackPage(BuildContext context,
    {MoeweTheme theme = const MoeweTheme(),
    FeedbackLabels labels = const FeedbackLabels()}) {
  Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (builder) => MoeweFeedbackPage(
            theme: theme,
            labels: labels,
          )));
}
