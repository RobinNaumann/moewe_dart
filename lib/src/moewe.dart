import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

part "crash/crash_logged.dart";
part 'moewe_config.dart';
part 'moewe_events.dart';
part "moewe_logger.dart";

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

typedef JsonMap = Map<String, dynamic>;

class PushEvent {
  final String type;
  final String key;
  final PushMeta meta;
  final JsonMap data;

  const PushEvent(this.type, this.key, this.meta, this.data);

  Map<String, dynamic> toMap() => {
        'type': type,
        'key': key,
        'meta': {'platform': meta.platform, 'device': meta.device},
        'data': data
      };
}

/// a shorthand for `Moewe.i`
/// this allows you to access the moewe client from anywhere
Moewe get moewe => Moewe.i;

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
  String? _appVersion;
  int? _buildNumber;
  late PushMeta _meta;
  bool sendIfDebug;

  String? get appVersion => _appVersion;
  int? get buildNumber => _buildNumber;

  /// this logger allows you to log messages to the server
  final MoeweLogger log = MoeweLogger._();

  /// this allows you to configure your app at runtime
  final MoeweConfig config = MoeweConfig._();

  /// allows you to log events to the server
  final MoeweEvents events = MoeweEvents._();

  /// creates a new instance of the moewe client
  /// [deviceModel] the model of the device you are logging from.
  /// [appVersion] the version of the app you are logging from.
  /// [sendIfDebug] if true, events will be sent even if the app is in debug mode
  Moewe(
      {required this.host,
      this.port = 80,
      required this.project,
      required this.app,
      this.sendIfDebug = false,
      String? appVersion,
      int? buildNumber,
      String? deviceModel}) {
    setAppVersion(appVersion, buildNumber);
    _i = this;
  }

  setAppVersion(String? version, int? buildNumber) {
    _appVersion = version;
    _buildNumber = buildNumber;
    _meta = PushMeta.fromDevice(Platform.operatingSystem, appVersion);
  }

  void crashHandlerInit() {
    FlutterError.onError = (details) {
      moewe.crash(details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      moewe.crash(error, stack);
      return true;
    };
  }

  /// initializes all components of the moewe client
  /// you can also call `init` on the individual components
  Future<void> init({bool timeout = true}) async {
    try {
      await config.init(timeout: timeout);
      crashHandlerInit();
    } catch (e) {
      print("[MOEWE] error while running init");
    }
  }

  /// pushes an event to the server<br>
  /// [key] this allows you to group simmilar events<br>
  /// [data] this is the data you want to push with the event
  /// the data can be any type that can be serialized to json
  void event(String key, {JsonMap? data}) => _push('event', key, data ?? {});

  /// log a crash to the server<br>
  /// [error] the error that caused the crash<br>
  /// [stackTrace] the stack trace of the crash
  void crash(dynamic error, StackTrace? stackTrace) {
    JsonMap data = {
      'error': error.toString(),
      'stack_trace': stackTrace?.toString()
    };
    _push('crash', 'crash', data);
  }

  /// logs a feedback message to the server<br>
  /// [title] the title of the feedback<br>
  /// [message] the message of the feedback<br>
  /// [type] the type of the feedback<br>
  /// [contact] the contact of the user
  Future<void> feedback(
      String title, String message, String type, String? contact) async {
    try {
      JsonMap data = {
        'title': title,
        'message': message,
        'type': type,
        'contact': contact,
        'open': true
      };
      await _send('feedback', type, data);
    } catch (e) {
      throw "could not send feedback";
    }
  }

  /// send a message without waiting for a response or confirmation
  void _push(String type, String key, JsonMap data) async {
    try {
      if (kDebugMode && !sendIfDebug) {
        print('[moewe] [APP IN DEBUG] not pushing: $type $key $data');
        return;
      }
      await _send(type, key, data);
    } catch (e) {
      print('[moewe] failed to log event: $e');
    }
  }

  Future<void> _send(String type, String key, JsonMap data) async {
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
