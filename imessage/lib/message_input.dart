import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Message, StreamChannel;

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                CupertinoIcons.tray_arrow_down_fill,
                color: CupertinoColors.systemGrey,
                size: 35,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                controller: textController,
                onSubmitted: (input) async {
                  await sendMessage(context, input);
                },
                placeholder: 'iMessage',
                prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "") //trick to add padding around  placeholder iMessage text
                    ),
                suffix: GestureDetector(
                  onTap: () async {
                    if (textController.value.text.isNotEmpty) {
                      await sendMessage(context, textController.value.text);
                      textController.clear();
                      // _updateList();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.arrow_up_circle_fill,
                        color: CupertinoColors.activeBlue, size: 35),
                  ),
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

  Future<void> sendMessage(BuildContext context, String input) async {
    final streamChannel = StreamChannel.of(context);
    await streamChannel.channel.sendMessage(Message(text: input));
  }
}
