import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message, StreamChannel;

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
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
                onSubmitted: (input) {
                  final streamChannel = StreamChannel.of(context);
                  streamChannel.channel.sendMessage(Message(text: input));
                },
                placeholder: 'iMessage', //TODO: send a message
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
      ),
    );
  }
}
