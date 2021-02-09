import 'package:flutter/cupertino.dart';
import 'package:imessage/channel_list_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show PaginationParams, SortOption, StreamChat, StreamChatClient, User;

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
    // @required this.conversations,
  }) : super(key: key);

  // final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);

    return StreamBuilder<User>(
        stream: streamChat.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CupertinoPageScaffold(
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (!snapshot.hasData) {
            return CupertinoPageScaffold(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          } else {
            print(snapshot.data.toJson());
            return Text("Welcome ${snapshot.data.name}");
            // snapshot.data.
            // return ChannelListPage(
            //     filter: {
            //       'members': {
            //         '\$in': [StreamChat.of(context).user.id],
            //       }
            //     },
            //     sort: [
            //       SortOption("last_message_at")
            //     ],
            //     pagination: PaginationParams(
            //       limit: 20,
            //     ));
          }
        });
  }
}
