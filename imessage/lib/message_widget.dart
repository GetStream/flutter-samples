import 'package:flutter/cupertino.dart';
import 'package:imessage/cutom_painter.dart';

class MessageWidget extends StatelessWidget {
  final Alignment alignment;
  final String message;
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            alignment, //Change this to Alignment.topRight or Alignment.topLeft
        child: CustomPaint(
          painter: ChatBubble(color: color, alignment: alignment),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16.0,8.0,8.0,8.0),
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
