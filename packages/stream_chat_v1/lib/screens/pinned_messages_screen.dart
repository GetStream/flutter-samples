import 'package:example/app/localizations.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/screens/channel_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PinnedMessagesScreen extends StatefulWidget {
  const PinnedMessagesScreen({Key? key}) : super(key: key);

  @override
  State<PinnedMessagesScreen> createState() => _PinnedMessagesScreenState();
}

class _PinnedMessagesScreenState extends State<PinnedMessagesScreen> {
  late final controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'cid',
      [StreamChannel.of(context).channel.cid!],
    ),
    messageFilter: Filter.equal(
      'pinned',
      true,
    ),
    sort: [
      SortOption(
        'created_at',
        direction: SortOption.ASC,
      ),
    ],
    limit: 20,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamChatTheme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: streamChatTheme.colorTheme.barsBg,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          appLocalizations.pinnedMessages,
          style: TextStyle(
            color: streamChatTheme.colorTheme.textHighEmphasis,
            fontSize: 16.0,
          ),
        ),
        leading: StreamBackButton(),
        backgroundColor: streamChatTheme.colorTheme.barsBg,
      ),
      body: StreamMessageSearchListView(
        controller: controller,
        emptyBuilder: (_) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamSvgIcon.pin(
                  size: 136.0,
                  color: streamChatTheme.colorTheme.disabled,
                ),
                SizedBox(height: 16.0),
                Text(
                  appLocalizations.noPinnedItems,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: streamChatTheme.colorTheme.textHighEmphasis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${appLocalizations.longPressMessage} ',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: streamChatTheme.colorTheme.textHighEmphasis
                            .withOpacity(0.5),
                      ),
                    ),
                    TextSpan(
                      text: appLocalizations.pinToConversation,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: streamChatTheme.colorTheme.textHighEmphasis
                            .withOpacity(0.5),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
        onMessageTap: (messageResponse) async {
          final client = StreamChat.of(context).client;
          final message = messageResponse.message;
          final channel = client.channel(
            messageResponse.channel!.type,
            id: messageResponse.channel!.id,
          );
          if (channel.state == null) {
            await channel.watch();
          }
          Navigator.of(context).pushNamed(
            Routes.CHANNEL_PAGE,
            arguments: ChannelPageArgs(
              channel: channel,
              initialMessage: message,
            ),
          );
        },
      ),
    );
  }
}
