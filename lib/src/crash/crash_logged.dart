part of '../moewe.dart';

extension CrashLogged on Moewe {
  crashLogged<T>(Future<T> Function() worker, {ZoneSpecification? specs}) {
    runZonedGuarded<Future<void>>(() async {
      await worker();
    }, (error, trace) => moewe.crash(error, trace), zoneSpecification: specs);
  }
}
