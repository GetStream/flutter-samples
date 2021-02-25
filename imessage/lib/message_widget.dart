import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:imessage/cutom_painter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message, AttachmentUploadStateBuilder;

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
    if (message.attachments?.isNotEmpty == true &&
        message.attachments.first.type == "image") {
      return MessageImage(
          color: color, message: message, messageColor: messageColor);
    } else {
      return MessageText(
          alignment: alignment,
          color: color,
          message: message,
          messageColor: messageColor);
    }
  }
}

class MessageImage extends StatelessWidget {
  const MessageImage({
    Key key,
    @required this.color,
    @required this.message,
    @required this.messageColor,
  }) : super(key: key);

  final Color color;
  final Message message;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    if (message.text != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: color,
                child: Column(
                  children: [
                    if (message.attachments.first.file != null)
                      Image.memory(
                        message.attachments.first.file.bytes,
                        fit: BoxFit.cover,
                      )
                    else
                      CachedNetworkImage(
                        imageUrl: message.attachments.first.thumbUrl ??
                            message.attachments.first.imageUrl ??
                            message.attachments.first.assetUrl,
                      ),
                    if (message.attachments.first?.title != null)
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
  }
}

class MessageText extends StatelessWidget {
  const MessageText({
    Key key,
    @required this.alignment,
    @required this.color,
    @required this.message,
    @required this.messageColor,
  }) : super(key: key);

  final Alignment alignment;
  final Color color;
  final Message message;
  final Color messageColor;

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
