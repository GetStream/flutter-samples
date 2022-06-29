import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
  connectionMode: ConnectionMode.regular,
);

StreamChatClient buildStreamChatClient(
    String apiKey, {
      Level logLevel = Level.INFO,
    }) {
  return StreamChatClient(
    apiKey,
    logLevel: logLevel,
    logHandlerFunction: sampleAppLogHandler,
  )..chatPersistenceClient = chatPersistentClient;
}

Future<void> sampleAppLogHandler(LogRecord record) async {
  if (kDebugMode) {
    StreamChatClient.defaultLogHandler(record);
  }
}
