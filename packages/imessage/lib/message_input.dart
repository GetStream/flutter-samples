import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Attachment, AttachmentFile, Message, StreamChannel;

class MessageInput extends StatefulWidget {
  const MessageInput({
    Key? key,
  }) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final textController = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {});
    });
  }

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
                    await (picker.pickImage(source: ImageSource.gallery));
                if (pickedFile == null) {
                  return;
                }
                final bytes = await File(pickedFile.path).readAsBytes();
                final channel = StreamChannel.of(context).channel;
                final message = Message(
                  text: textController.value.text,
                  attachments: [
                    Attachment(
                      type: 'image',
                      file: AttachmentFile(
                        bytes: bytes,
                        path: pickedFile.path,
                        size: bytes.length,
                      ),
                    ),
                  ],
                );
                await channel.sendMessage(message);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.camera_fill,
                  color: CupertinoColors.systemGrey,
                  size: 32,
                ),
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                controller: textController,
                maxLines: 10,
                minLines: 1,
                onSubmitted: (input) async {
                  await sendMessage(context, input);
                },
                placeholder: 'iMessage',
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                suffixMode: OverlayVisibilityMode.editing,
                suffix: GestureDetector(
                  onTap: () async {
                    if (textController.value.text.isNotEmpty) {
                      await sendMessage(context, textController.value.text);
                      textController.clear();
                    }
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_up_circle_fill,
                    color: CupertinoColors.activeBlue,
                    size: 35,
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.systemGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage(BuildContext context, String input) async {
    final streamChannel = StreamChannel.of(context);
    await streamChannel.channel.sendMessage(Message(text: input.trim()));
  }
}
