import 'package:stream_chatter/domain/models/chat_user.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class StreamApiRepository {
  Future<List<ChatUser>> getChatUsers();
  Future<String?> getToken(String userId);
  Future<bool> connectIfExist(String userId);
  Future<ChatUser> connectUser(ChatUser user, String? token);
  Future<Channel> createGroupChat(
      String channelId, String? name, List<String?>? members,
      {String? image});
  Future<Channel> createSimpleChat(String? friendId);
  Future<void> logout();
}
