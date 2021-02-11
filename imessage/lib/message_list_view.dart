
import 'package:flutter/cupertino.dart';
import 'package:imessage/message_header.dart';
import 'package:imessage/message_input.dart';
import 'package:imessage/message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message,  StreamChatCore;

class MessageListView extends StatelessWidget {
  const MessageListView({Key key, this.messages}) : super(key: key);
  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Align(
          alignment: FractionalOffset.topCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              ...messages //TODO: oder by
                  .map((message) => Column(
                        children: [
                          MessageHeader(
                            receivedAt: message.updatedAt,
                          ),
                          MessageWidget(
                              alignment: isReceived(message, context)
                                  ? Alignment.centerLeft
                                  : Alignment.topRight,
                              color: isReceived(message,context)
                                  ? CupertinoColors.systemGrey5
                                  : CupertinoColors.systemBlue,
                              messageColor: isReceived(message,context)
                                  ? CupertinoColors.black
                                  : CupertinoColors.white,
                              message: message.text)
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
      MessageInput()
    ]);
  }

  bool isReceived(Message message, BuildContext context) {
    final currentUserId = StreamChatCore.of(context).user.id;
    return message.user.id == currentUserId;
  }
}
