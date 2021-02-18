import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:imessage/cutom_painter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' show Message;

class MessageWidget extends StatelessWidget {
  final Alignment alignment;
  final Message message;
  final Color color;
  final Color messageColor;

  const MessageWidget(
      {Key key,
      @required this.alignment,
      @required this.message,
      @required this.color,
      @required this.messageColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.attachments.isNotEmpty &&
        message.attachments.first.type == "image") {
      print("type : ${message.attachments.first.assetUrl}");
      if (message.text != null) {
        print(message.attachments.first.toJson());
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // message.text.contains("http")
              //     ? Container()
              //     : Text(message.text), //no need to display link
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: color,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: message.attachments.first.thumbUrl ??
                            message.attachments.first.imageUrl ??
                            message.attachments.first.assetUrl,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(message.attachments.first.title,
                            style: TextStyle(color: messageColor)),
                      ),
                      message.attachments.first.pretext != null
                          ? Text(message.attachments.first.pretext)
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: color,
              child: CachedNetworkImage(
                imageUrl: message.attachments.first.thumbUrl,
              )),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment:
              alignment, //Change this to Alignment.topRight or Alignment.topLeft
          child: CustomPaint(
            painter: ChatBubble(color: color, alignment: alignment),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.65),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        message.text,
                        style: TextStyle(color: messageColor),
                      ),
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
}
