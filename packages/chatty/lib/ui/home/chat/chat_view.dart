import 'package:stream_chatter/ui/common/my_channel_preview.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).appBarTheme.color;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: ChannelsBloc(
        child: ChannelListView(
          filter: {
            'members': {
              '\$in': [StreamChat.of(context).user?.id],
            }
          },
          sort: [SortOption('last_message_at')],
          channelPreviewBuilder: (context, channel) {
            return Container(
              color: Theme.of(context).canvasColor,
              child: MyChannelPreview(
                channel: channel,
                heroTag: channel.id,
                onImageTap: () {
                  String name;
                  String image;
                  final currentUser = StreamChat.of(context).client.state.user;
                  if (channel.isGroup) {
                    name = channel.extraData['name'];
                    image = channel.extraData['image'];
                  } else {
                    final friend =
                        channel.state.members.where((element) => element.userId != currentUser.id).first.user;
                    name = friend.name;
                    image = friend.extraData['image'];
                  }

                  return Navigator.of(context).push(
                    PageRouteBuilder(
                        barrierColor: Colors.black45,
                        barrierDismissible: true,
                        opaque: false,
                        pageBuilder: (context, animation1, _) {
                          return FadeTransition(
                            opacity: animation1,
                            child: ChatDetailView(
                              channelId: channel.id,
                              image: image,
                              name: name,
                            ),
                          );
                        }),
                  );
                },
                onTap: (channel) => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return StreamChannel(
                          child: ChannelPage(),
                          channel: channel,
                        );
                      },
                    ),
                  )
                },
              ),
            );
          },
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: [
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}

class ChatDetailView extends StatelessWidget {
  const ChatDetailView({
    Key key,
    this.image,
    this.name,
    this.channelId,
  }) : super(key: key);

  final String image;
  final String name;
  final String channelId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: Material(
        color: Colors.transparent,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: channelId,
                  child: ClipOval(
                    child: Image.network(
                      image,
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
