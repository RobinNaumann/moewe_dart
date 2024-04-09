part of 'moewe.dart';

class MoeweLogger {
  final Moewe _moewe;
  MoeweLogger._(this._moewe);

  /// logs a debug message to the server and prints it to the console
  void debug(String msg) => _log("debug", msg);

  /// logs an info message to the server and prints it to the console
  void info(String msg) => _log("info", msg);

  /// logs a warning message to the server and prints it to the console
  void warn(String msg) => _log("warn", msg);

  /// logs an error message to the server and prints it to the console
  void error(String msg) => _log("error", msg);

  /// logs an unknown message to the server and prints it to the console
  void unknown(String msg) => _log("unknown", msg);

  void _log(String lvl, String msg) {
    print("[MOEWE] LOG: $lvl: $msg");
    _moewe._push('log', lvl, {msg: msg});
  }
}
