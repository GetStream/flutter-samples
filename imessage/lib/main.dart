import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show
        Channel,
        ChannelListController,
        ChannelListCore,
        ChannelsBloc,
        LazyLoadScrollView,
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
    var channelListController = ChannelListController();
    return CupertinoPageScaffold(
        child: ChannelsBloc(
            child: ChannelListCore(
                channelListController: channelListController,
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
                sort: [SortOption('last_message_at')],
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
                    LazyLoadScrollView(
                      onEndOfPage: () async {
                        return channelListController.paginateData();
                      },
                      child: CustomScrollView(slivers: [
                        CupertinoSliverRefreshControl(onRefresh: () async {
                          channelListController.loadData();
                        }),
                        ChannelPageAppBar(),
                        ChannelListView(channels: channels)
                      ]),
                    ))));
  }
}
