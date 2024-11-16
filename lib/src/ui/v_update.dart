import 'package:flutter/material.dart';
import 'package:moewe/moewe.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// if there is a newer version of the app available, this view is shown
/// to the user. It can be used to inform the user about new features or
/// guide them to the new version.
/// requires `moewe.setAppVersion` to be used within `main()`;
class MoeweUpdateView extends StatefulWidget {
  final MoeweTheme theme;
  final IconData? icon;
  final bool closeable;
  final String title;
  final String message;
  final String? url;

  /// externally manage the state of the view
  /// use this in combination with [onClosed].
  /// If it is null, the view will manage its own state.
  final bool? isClosed;

  /// called when the view is closed
  final Function()? onClosed;

  const MoeweUpdateView(
      {super.key,
      this.theme = const MoeweTheme(),
      this.icon = Icons.flare,
      this.closeable = true,
      this.title = "a new version is available",
      this.message = "get the newest features",
      this.url,
      this.isClosed,
      this.onClosed});

  @override
  createState() => _State();
}

class _State extends State<MoeweUpdateView> {
  bool closed = false;

  @override
  Widget build(BuildContext context) {
    final bool up = moewe.config.isLatestVersion() ?? true;
    return moewe.storeManaged || up || (widget.isClosed ?? closed)
        ? SizedBox()
        : Material(
            child: GestureDetector(
              onTap: () {
                widget.url != null ? launchUrlString(widget.url ?? "") : null;
              },
              child: Container(
                padding: EdgeInsets.all(widget.theme.remSize),
                decoration: BoxDecoration(
                  color: widget.theme.colorAccent,
                ),
                child: Row(
                  children: [
                    Icon(widget.icon, color: widget.theme.colorOnAccent),
                    SizedBox(width: widget.theme.remSize),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(widget.title,
                              style: TextStyle(
                                  color: widget.theme.colorOnAccent,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.message,
                              style:
                                  TextStyle(color: widget.theme.colorOnAccent)),
                        ],
                      ),
                    ),
                    SizedBox(width: widget.theme.remSize / 2),
                    if (widget.closeable)
                      IconButton(
                          onPressed: () {
                            widget.onClosed?.call();
                            setState(() => closed = true);
                          },
                          icon: Icon(Icons.close,
                              color: widget.theme.colorOnAccent)),
                  ],
                ),
              ),
            ),
          );
  }
}

moeweUpdateWrapper({
  required Widget child,
  MoeweTheme? theme = const MoeweTheme(),
  IconData? icon = Icons.flare,
  bool closeable = true,
  String title = "a new version is available",
  String message = "get the newest features",
  String? url,
}) {
  return Column(
    children: [
      MoeweUpdateView(
        theme: theme ?? const MoeweTheme(),
        icon: icon,
        closeable: closeable,
        title: title,
        message: message,
        url: url,
      ),
      Expanded(child: child),
    ],
  );
}
