import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:imessage/channel_list_view.dart';

import 'package:imessage/channel_page_appbar.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO); //

  // For demonstration purposes. Fixed user and token.
  await client.connectUser(
    User(
      id: 'cool-shadow-7',
      extraData: const {
        'image':
            'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo',
  );

  runApp(IMessage(client: client));
}

class IMessage extends StatelessWidget {
  const IMessage({Key? key, required this.client}) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_US', null);
    return CupertinoApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: StreamChatCore(client: client, child: ChatLoader()),
    );
  }
}

class ChatLoader extends StatefulWidget {
  const ChatLoader({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatLoader> createState() => _ChatLoaderState();
}

class _ChatLoaderState extends State<ChatLoader> {
  StreamChannelListController? _channelListController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_channelListController
        case final StreamChannelListController controller) {
      controller.dispose();
    }

    final streamChat = StreamChatCore.of(context);

    _channelListController = StreamChannelListController(
      client: streamChat.client,
      filter: Filter.and([
        Filter.in_('members', [streamChat.currentUser!.id]),
        Filter.equal('type', 'messaging'),
      ]),
      channelStateSort: const [SortOption('last_message_at')],
      limit: 20,
    )..doInitialLoad();
  }

  @override
  void dispose() {
    _channelListController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelListController = _channelListController!;

    return CupertinoPageScaffold(
      child: PagedValueListenableBuilder<int, Channel>(
        valueListenable: channelListController,
        builder: (context, value, child) {
          return value.when(
            (channels, nextPageKey, error) => LazyLoadScrollView(
              onEndOfPage: () async {
                if (nextPageKey != null) {
                  channelListController.loadMore(nextPageKey);
                }
              },
              child: channels.isEmpty
                  ? const Center(
                      child: Text('Looks like you are not in any channels'),
                    )
                  : CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(onRefresh: () async {
                          return channelListController.refresh();
                        }),
                        const ChannelPageAppBar(),
                        SliverPadding(
                          sliver: ChannelListView(channels: channels),
                          padding: const EdgeInsets.only(top: 16),
                        )
                      ],
                    ),
            ),
            loading: () => const Center(
              child: SizedBox(
                height: 100.0,
                width: 100.0,
                child: CupertinoActivityIndicator(),
              ),
            ),
            error: (e) => const Center(
              child: Text(
                  'Oh no, something went wrong. Please check your config.'),
            ),
          );
        },
      ),
    );
  }
}
