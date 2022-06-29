import 'dart:async';

import 'package:example/app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  const sentryDsn =
      'https://6381ef88de4140db8f5e25ab37e0f08c@o1213503.ingest.sentry.io/6352870';

  /// Captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  Future<void> _reportError(dynamic error, StackTrace stackTrace) async {
    // Print the exception to the console.
    if (kDebugMode) {
      // Print the full stacktrace in debug mode.
      print(stackTrace);
      return;
    } else {
      // Send the Exception and Stacktrace to sentry in Production mode.
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  runZonedGuarded(
    () async {
      await SentryFlutter.init(
        (options) => options.dsn = sentryDsn,
      );
      runApp(ChatAppV1());
    },
    _reportError,
  );
}
