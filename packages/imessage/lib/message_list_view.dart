import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:imessage/message_header.dart';
import 'package:imessage/message_input.dart';
import 'package:imessage/message_widget.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Message, StreamChatCore;

class MessageListView extends StatelessWidget {
  const MessageListView({Key? key, this.messages}) : super(key: key);
  final List<Message>? messages;

  @override
  Widget build(BuildContext context) {
    final entries = groupBy(messages!,
            (Message message) => message.createdAt.toString().substring(0, 10))
        .entries
        .toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: ListView.builder(
                      reverse: true,
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 24.0, 8.0, 8.0),
                              child: MessageHeader(
                                  rawTimeStamp: entries[index].key), //date
                            ),
                            ...entries[index]
                                .value //messages
                                .asMap()
                                .entries
                                .map(
                                  (entry) {
                                    final message = entry.value;
                                    final isFinalMessage = 0 == entry.key;
                                    final received =
                                        isReceived(message, context);
                                    return (received)
                                        ? MessageWidget(
                                            alignment: Alignment.topRight,
                                            margin: const EdgeInsets.fromLTRB(
                                                8.0, 4.0, 16.0, 4.0),
                                            color: const Color(0xFF3CABFA),
                                            messageColor: CupertinoColors.white,
                                            message: message,
                                            hasTail: isFinalMessage,
                                          )
                                        : MessageWidget(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.fromLTRB(
                                                16.0, 4.0, 8.0, 4.0),
                                            color: CupertinoColors.systemGrey5,
                                            messageColor: CupertinoColors.black,
                                            message: message,
                                            hasTail: isFinalMessage,
                                          );
                                  },
                                )
                                .toList()
                                .reversed,
                          ],
                        );
                      }),
                )),
          ),
          const MessageInput()
        ],
      ),
    );
  }

  bool isReceived(Message message, BuildContext context) {
    final currentUserId = StreamChatCore.of(context).currentUser!.id;
    return message.user!.id == currentUserId;
  }

  bool isSameDay(Message message) =>
      message.createdAt.day == DateTime.now().day;
}
