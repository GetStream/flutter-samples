import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class InitData {
  InitData(this.client, this.preferences);

  final StreamChatClient client;
  final StreamingSharedPreferences preferences;
}