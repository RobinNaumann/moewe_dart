part of 'moewe.dart';

class MoeweConfig {
  final Moewe _moewe;
  AppConfig? _config;

  init() async {
    _config = await _moewe._getAppConfig();
  }

  MoeweConfig._(this._moewe);

  /// checks if the current version is the latest version of the app
  /// if the version could not be determined, null is returned
  /// if the version is the latest version, true is returned
  ///
  /// **make sure to call (and `await`) `init()` before using this**
  bool? isLatestVersion() {
    final v = int.tryParse(flagString("version")?.split("+").lastOrNull ?? "ü");
    return v == null ? null : v == _moewe.buildNumber;
  }

  /// returns the name of the app
  ///
  /// **make sure to call (and `await`) `init()` before using this**
  String? appName() => _config?.name;

  /// returns the value of the key given key as an integer<br>
  /// if the key does not exist or the value is not an integer, null is returned
  ///
  /// **make sure to call (and `await`) `init()` before using flags**
  int? flagInt(String key) => _flag<int>(key);

  /// returns the value of the key given key as a string<br>
  /// if the key does not exist or the value is not a string, null is returned
  ///
  /// **make sure to call (and `await`) `init()` before using flags**
  String? flagString(String key) => _flag<String>(key);

  /// returns the value of the key given key as a boolean<br>
  /// if the key does not exist or the value is not a boolean, null is returned
  ///
  /// **make sure to call (and `await`) `init()` before using flags**
  bool? flagBool(String key) => _flag<bool>(key);

  T? _flag<T>(String key) {
    try {
      return _config!.config[key] as T;
    } catch (e) {
      return null;
    }
  }
}
