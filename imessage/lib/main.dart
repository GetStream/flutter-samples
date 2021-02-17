import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show
        Channel,
        ChannelListCore,
        ChannelsBloc,
        Level,
        PaginationParams,
        SortOption,
        StreamChatClient,
        StreamChatCore,
        User;

import 'package:imessage/channel_list_view.dart';

import 'package:imessage/channel_page_appbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = StreamChatClient('s2dxdhpxd94g', logLevel: Level.INFO);
  await client.connectUser(
    User(
      id: 'empty-queen-5',
      extraData: {
        'name': 'Paranoid Android',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZW1wdHktcXVlZW4tNSJ9.RJw-XeaPnUBKbbh71rV1bYAKXp6YaPARh68O08oRnOU',
  );

  // final channel = client.channel(
  //   "messaging",
  //   extraData: {
  //     "name": "Founder Chat",
  //     "image": "http://bit.ly/2O35mws",
  //     "members": ["polished-poetry-5"],
  //   },
  // );
  // await channel.create();

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
      home: StreamChatCore(client: client, child: ChatLoader()),
    );
  }
}

class ChatLoader extends StatelessWidget {
  const ChatLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = StreamChatCore.of(context).user;
    return CupertinoPageScaffold(
        child: ChannelsBloc(
            child: ChannelListCore(
                filter: {
          r'$and': [
            {
              'members': {
                r'$in': [user.id],
              }
            },
            {
              'type': {
                r'$eq': 'messaging',
              }
            }
          ]
        },
                sort: [
          SortOption('last_message_at')
        ],
                pagination: PaginationParams(
                  limit: 20,
                ),
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
                      ChannelListView(channels: channels)
                    ]))));
  }
}
