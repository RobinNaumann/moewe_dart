import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

part "moewe_logger.dart";

class PushMeta {
  final String? platform;
  final String? device;

  const PushMeta({this.platform, this.device});

  /// getting the device type would require platform specific code
  /// and thus depend on the flutter SDK
  factory PushMeta.fromDevice(String? model) =>
      PushMeta(platform: Platform.operatingSystem, device: model);
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
  final String appId;
  final String appVersion;
  late PushMeta _meta;

  /// this logger allows you to log messages to the server
  late MoeweLogger log;

  /// creates a new instance of the moewe client
  /// [deviceModel] the model of the device you are logging from
  Moewe(
      {required this.host,
      this.port = 80,
      required this.project,
      required this.appId,
      required this.appVersion,
      String? deviceModel}) {
    _meta = PushMeta.fromDevice(deviceModel);
    log = MoeweLogger._(this);
    _i = this;
  }

  /// logs an event to the server<br>
  /// [key] this allows you to group simmilar events<br>
  /// [data] this is the data you want to push with the event
  /// the data can be any type that can be serialized to json
  void event(String key, [dynamic data]) => _push('event', key, data);

  void crash(dynamic error, StackTrace stackTrace) {
    final data = {
      'error': error.toString(),
      'stackTrace': stackTrace.toString()
    };
    _push('crash', 'crash', data);
  }

  void _push(String type, String key, dynamic data) async {
    try {
      final event = PushEvent(type, key, _meta, data);

      final url = Uri.https('$host:$port', '/api/log/$project');
      final headers = {
        'Content-Type': 'application/json',
        "MOEWE-APPID": appId,
        "MOEWE-APPVERSION": appVersion
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
}
