import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    show Attachment, AttachmentFile, Message, MultipartFile, StreamChannel;

class MessageInput extends StatefulWidget {
  const MessageInput({
    Key key,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final textController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                final bytes = await File(pickedFile.path).readAsBytes();
                final channel = StreamChannel.of(context).channel;
                final message =
                    Message(text: textController.value.text, attachments: [
                  Attachment(
                    type: 'image',
                    file: AttachmentFile(bytes: bytes, path: pickedFile.path),
                  ),
                ]);
                await channel.sendMessage(message);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.systemGrey,
                  size: 35,
                ),
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                controller: textController,
                onSubmitted: (input) async {
                  await sendMessage(context, input);
                },
                placeholder: 'Text Message',
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
                        color: CupertinoColors.activeGreen, size: 35),
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
