part of 'moewe.dart';

class MoeweConfig {
  AppConfig? _config;

  /// initializes the config
  /// this method should be called before using any other methods
  /// if [timeout] is true, the method will timeout after 1 second
  /// and return null. this is so that the app does not hang if the
  /// server is not reachable. You can override this by setting
  /// [timeout] to false
  Future<void> init({bool timeout = true}) async {
    try {
      _config = timeout
          ? await moewe._getAppConfig().timeout(const Duration(seconds: 1))
          : await moewe._getAppConfig();
    } catch (e) {
      print("[MOEWE] Could not fetch app config. \n"
          "if this is a timeout, you can disable it by calling `init(timeout: false)`");
    }
  }

  MoeweConfig._();

  /// checks if the current version is the latest version of the app
  /// if the version could not be determined, null is returned
  /// if the version is the latest version, true is returned
  ///
  /// **make sure to call (and `await`) `init()` before using this**
  bool? isLatestVersion() {
    if (moewe.buildNumber == null) return null;
    final v = int.tryParse(flagString("version")?.split("+").lastOrNull ?? "ü");
    return v == null ? null : v <= (moewe.buildNumber ?? 0);
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
