import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show
        Channel,
        ChannelListCore,
        ChannelsBloc,
        PaginationParams,
        SortOption,
        StreamChat,
        StreamChatClient,
        StreamChatCore,
        User;

import 'package:imessage/channel_list_view.dart';

import 'channel_page_appbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = StreamChatClient("b67pax5b2wdq");
  await client.connectUser(
    User(id: "polished-poetry-5"),
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoicG9saXNoZWQtcG9ldHJ5LTUifQ.o8SWzSlb68EntudwjVul1rUCYGpla-CimXNKxj3wKOc",
  );

  runApp(IMessage(client: client));
}

class IMessage extends StatelessWidget {
  final StreamChatClient client;
  IMessage({@required this.client});
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_US', null);
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: StreamChat(client: client, child: ChatLoader()),
    );
  }
}

class ChatLoader extends StatelessWidget {
  const ChatLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: ChannelsBloc(
            child: ChannelListCore(
                emptyBuilder: (BuildContext context) {
                  return Center(
                    child: Text('Looks like you are not in any channels'),
                  );
                },
                loadingBuilder: (BuildContext context) {
                  return Center(
                    child: SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                },
                errorBuilder: (BuildContext context, dynamic error) {
                  return Center(
                    child: Text(
                        'Oh no, something went wrong. Please check your config.'),
                  );
                },
                listBuilder: (
                  BuildContext context,
                  List<Channel> channels,
                ) =>
                    CustomScrollView(slivers: [
                      ChannelPageAppBar(),
                      ChannelListView(channelsStates: channels)
                    ]))));
  }
}
