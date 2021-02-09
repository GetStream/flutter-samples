import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_page_appbar.dart';
import 'package:imessage/channel_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Channel, PaginationParams, SortOption, StreamChannel, StreamChat;

class ChannelListPage extends StatelessWidget {
  final Map<String, dynamic> filter;
  final Map<String, dynamic> options;
  final List<SortOption> sort;
  final PaginationParams pagination;

  const ChannelListPage({
    Key key,
    this.filter,
    this.options,
    this.sort,
    this.pagination,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context).client.state.channelsStream;
    // print(streamChat);
    streamChat.toList().then((value) => print(value));
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          ChannelPageAppBar(),
          StreamBuilder<Map<String, Channel>>(
              stream: streamChat,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  print((snapshot.error as Error).stackTrace);
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                final channelsStream = snapshot.data;
                final channelsStates = channelsStream.values;
                return ChannelListView(channelsStates: channelsStates.toList());
              }),
        ],
      ),
    );
  }
}
