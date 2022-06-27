import 'package:collection/collection.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPageArgs {
  final Channel? channel;
  final Message? initialMessage;

  const ChannelPageArgs({
    this.channel,
    this.initialMessage,
  });
}

class ChannelPage extends StatefulWidget {
  final int? initialScrollIndex;
  final double? initialAlignment;
  final bool highlightInitialMessage;

  const ChannelPage({
    Key? key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
  }) : super(key: key);

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  FocusNode? _focusNode;
  StreamMessageInputController _messageInputController =
      StreamMessageInputController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  bool defaultFilter(Message m) {
    var _currentUser = StreamChat.of(context).currentUser;
    final isMyMessage = m.user?.id == _currentUser?.id;
    final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
    if (isDeletedOrShadowed && !isMyMessage) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamChannelHeader(
        showTypingIndicator: false,
        onImageTap: () async {
          var channel = StreamChannel.of(context).channel;

          if (channel.memberCount == 2 && channel.isDistinct) {
            final currentUser = StreamChat.of(context).currentUser;
            final otherUser = channel.state!.members.firstWhereOrNull(
              (element) => element.user!.id != currentUser!.id,
            );
            if (otherUser != null) {
              final pop = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StreamChannel(
                    child: ChatInfoScreen(
                      messageTheme: StreamChatTheme.of(context).ownMessageTheme,
                      user: otherUser.user,
                    ),
                    channel: channel,
                  ),
                ),
              );

              if (pop == true) {
                Navigator.of(context).pop();
              }
            }
          } else {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  child: GroupInfoScreen(
                    messageTheme: StreamChatTheme.of(context).ownMessageTheme,
                  ),
                  channel: channel,
                ),
              ),
            );
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamMessageListView(
                  initialScrollIndex: widget.initialScrollIndex,
                  initialAlignment: widget.initialAlignment,
                  highlightInitialMessage: widget.highlightInitialMessage,
                  onMessageSwiped: _reply,
                  messageFilter: defaultFilter,
                  messageBuilder: (context, details, messages, defaultMessage) {
                    return defaultMessage.copyWith(
                      onReplyTap: _reply,
                      onShowMessage: (m, c) async {
                        final client = StreamChat.of(context).client;
                        final message = m;
                        final channel = client.channel(
                          c.type,
                          id: c.id,
                        );
                        if (channel.state == null) {
                          await channel.watch();
                        }
                        Navigator.of(context).pushReplacementNamed(
                          Routes.CHANNEL_PAGE,
                          arguments: ChannelPageArgs(
                            channel: channel,
                            initialMessage: message,
                          ),
                        );
                      },
                      deletedBottomRowBuilder: (context, message) {
                        return const StreamVisibleFootnote();
                      },
                    );
                  },
                  threadBuilder: (_, parentMessage) {
                    return ThreadPage(parent: parentMessage!);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .appBg
                        .withOpacity(.9),
                    child: StreamTypingIndicator(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      style: StreamChatTheme.of(context)
                          .textTheme
                          .footnote
                          .copyWith(
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .textLowEmphasis),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamMessageInput(
            focusNode: _focusNode,
            messageInputController: _messageInputController,
          ),
        ],
      ),
    );
  }
}
