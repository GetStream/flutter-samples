import 'package:flutter/cupertino.dart';
import 'package:imessage/utils.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(IMessage());
}

class IMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_US', null);
    final conversations = [
      Conversation(
          messages: [
            Message(
                isReceived: true,
                body: "Whatsup",
                receivedAt: DateTime(2021, DateTime.january, 20, 15, 31)),
            Message(
                isReceived: false,
                body: "I'm fine and you?",
                receivedAt: DateTime(2021, DateTime.january, 20, 15, 32))
          ],
          contact: Contact(
              contact: "Daniel Kaluuya",
              avatarUrl:
                  "https://4.bp.blogspot.com/-Jx21kNqFSTU/UXemtqPhZCI/AAAAAAAAh74/BMGSzpU6F48/s1600/funny-cat-pictures-047-001.jpg"))
    ];
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: MessagesPage(conversations: conversations),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({
    Key key,
    @required this.conversations,
  }) : super(key: key);

  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Messages'),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    MessagePreview(
                        from: conversations[index].contact,
                        message: conversations[index].lastMessage(),
                        onTap: () {
                          //TODO:transition animation
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MessageDetail(
                                    conversation: conversations[index])),
                          );
                        })
                  ],
                );
              },
              childCount: conversations.length,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageDetail extends StatelessWidget {
  final Conversation conversation;
  const MessageDetail({Key key, @required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Column(
          children: [
            CupertinoCircleAvatar(
                size: 25, url: conversation.contact.avatarUrl),
            Expanded(child: Text(conversation.contact.contact))
          ],
        ),
      ),
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ...conversation.messages //TODO: oder by
                    .map((message) => Column(
                          children: [
                            ChatMessageHeader(
                              receivedAt: message.receivedAt,
                            ),
                            ChatMessage(
                                alignment: message.isReceived
                                    ? Alignment.centerLeft
                                    : Alignment.topRight,
                                color: message.isReceived
                                    ? CupertinoColors.systemGrey5
                                    : CupertinoColors.systemBlue,
                                messageColor: message.isReceived
                                    ? CupertinoColors.black
                                    : CupertinoColors.white,
                                message: message.body)
                          ],
                        ))
                    .toList(),
                SendMessageInput()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SendMessageInput extends StatelessWidget {
  const SendMessageInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              CupertinoIcons.camera_fill,
              color: CupertinoColors.systemGrey,
              size: 35,
            ),
          ),
          Expanded(
            child: CupertinoTextField(
              placeholder: "iMessage",
              prefix: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.add_circled,
                  size: 35,
                  color: CupertinoColors.systemGrey4,
                ),
              ),
              suffix: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.waveform_circle_fill,
                    color: CupertinoColors.systemGrey, size: 35),
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.systemGrey,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
            ),
          ),
        ],
      ),
    ));
  }
}

class ChatMessageHeader extends StatelessWidget {
  final DateTime receivedAt;
  const ChatMessageHeader({Key key, @required this.receivedAt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'iMessage',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
        Text(formatDate(receivedAt))
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Alignment alignment;
  final String message;
  final Color color;
  final Color messageColor;

  const ChatMessage(
      {Key key,
      @required this.alignment,
      @required this.message,
      @required this.color,
      @required this.messageColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            alignment, //Change this to Alignment.topRight or Alignment.topLeft
        child: CustomPaint(
          painter: ChatBubble(color: color, alignment: alignment),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    message,
                    style: TextStyle(color: messageColor),
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

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;

  ChatBubble({
    @required this.color,
    this.alignment,
  });

  final _radius = 10.0;
  final _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 8,
            size.height,
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
      var path = Path();
      path.moveTo(size.width - _x, size.height - 20);
      path.lineTo(size.width - _x, size.height);
      path.lineTo(size.width, size.height);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - _x,
            0.0,
            size.width,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
      var path = Path();
      path.moveTo(0, size.height);
      path.lineTo(_x, size.height);
      path.lineTo(_x, size.height - 20);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            _x,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MessagePreview extends StatelessWidget {
  final VoidCallback onTap;
  final Message message;
  final Contact from;
  const MessagePreview(
      {Key key,
      @required this.onTap,
      @required this.message,
      @required this.from})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: CupertinoColors.white),
        child: CupertinoListTile(
          onTap: onTap,
          // shape: RoundedRectangleBorder(),

          leading: CupertinoCircleAvatar(
            size: 50,
            url: from.avatarUrl,
          ),
          title: Text(
            from.contact,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.black),
          ),
          trailing: Text(
            formatDate(message.receivedAt),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: CupertinoColors.systemGrey),
          ),
          subtitle: Text(
            message.body,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: CupertinoColors.systemGrey),
          ),
        ),
      ),
    );
  }
}

class Message {
  final bool isReceived;
  final DateTime receivedAt;
  final String body;

  Message(
      {@required this.receivedAt,
      @required this.body,
      @required this.isReceived});
}

class Conversation {
  final Contact contact;
  final List<Message> messages;
  Conversation({@required this.messages, @required this.contact});

  lastMessage() => messages.last;
}

class Contact {
  final String contact; //name or number
  final String avatarUrl;
  Contact({@required this.avatarUrl, @required this.contact});
}
