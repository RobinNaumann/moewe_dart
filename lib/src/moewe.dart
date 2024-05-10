import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

part "moewe_logger.dart";
part 'moewe_config.dart';
part 'moewe_events.dart';

class AppConfig {
  final String id;
  final String name;
  final Map<String, dynamic> config;

  AppConfig(this.id, this.name, this.config);
}

class PushMeta {
  final String? platform;
  final String? device;
  final String? appVersion;

  const PushMeta({this.platform, this.device, this.appVersion});

  /// getting the device type would require platform specific code
  /// and thus depend on the flutter SDK
  factory PushMeta.fromDevice(String? model, String? appVersion) => PushMeta(
      platform: Platform.operatingSystem,
      device: model,
      appVersion: appVersion);
}

class PushEvent {
  final String type;
  final String key;
  final PushMeta meta;
  final dynamic data;

  const PushEvent(this.type, this.key, this.meta, this.data);

  Map<String, dynamic> toMap() => {
        'type': type,
        'key': key,
        'meta': {'platform': meta.platform, 'device': meta.device},
        'data': data
      };
}

class Moewe {
  static Moewe? _i;

  static Moewe get i => _i ?? (() => throw "Moewe not initialized")();

  /// [host] the host of the server. e.g. `moewe.example.com`
  final String host;

  /// [port] the port of the server. default is 80
  final int port;

  /// [project] the project you want to log to
  final String project;
  final String app;
  final String appVersion;
  final int buildNumber;
  late PushMeta _meta;

  /// this logger allows you to log messages to the server
  late MoeweLogger log;

  /// this allows you to configure your app at runtime
  late MoeweConfig config;

  /// allows you to log events to the server
  late MoeweEvents event;

  /// creates a new instance of the moewe client
  /// [deviceModel] the model of the device you are logging from
  Moewe(
      {required this.host,
      this.port = 80,
      required this.project,
      required this.app,
      required this.appVersion,
      required this.buildNumber,
      String? deviceModel}) {
    _meta = PushMeta.fromDevice(deviceModel, appVersion);
    log = MoeweLogger._(this);
    config = MoeweConfig._(this);
    _i = this;
  }

  /// log a crash to the server<br>
  /// [error] the error that caused the crash<br>
  /// [stackTrace] the stack trace of the crash
  void crash(dynamic error, StackTrace stackTrace) {
    final data = {
      'error': error.toString(),
      'stackTrace': stackTrace.toString()
    };
    _push('crash', 'crash', data);
  }

  /// logs a feedback message to the server<br>
  /// [title] the title of the feedback<br>
  /// [message] the message of the feedback<br>
  /// [type] the type of the feedback<br>
  /// [contact] the contact of the user
  void feedback(String title, String message, String type, String? contact) {
    final data = {'title': title, 'message': message, 'contact': contact};
    _push('feedback', type, data);
  }

  void _push(String type, String key, dynamic data) async {
    try {
      final event = PushEvent(type, key, _meta, data);

      final url = Uri.https('$host:$port', '/api/use/$project/$app/log');
      final headers = {
        'Content-Type': 'application/json',
        //"MOEWE-APPID": app,
        //"MOEWE-APPVERSION": appVersion
      };
      final body = jsonEncode(event.toMap());

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode != 200) {
        throw "Server responded with ${response.statusCode}";
      }
    } catch (e) {
      print('[moewe] failed to log event: $e');
    }
  }

  Future<AppConfig?> _getAppConfig() async {
    try {
      final url = Uri.https('$host:$port', '/api/use/$project/$app/config');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw "Server responded with ${response.statusCode}";
      }

      final data = jsonDecode(response.body);
      return AppConfig(data['id'], data['name'], data['config']);
    } catch (e) {
      print('[moewe] failed to get app config: $e');
      return null;
    }
  }
}
