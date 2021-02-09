
// import 'package:flutter/cupertino.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart'show StreamChannel;

// import 'utils.dart';

// class ChannelHeader extends StatelessWidget {
//   const ChannelHeader({
//     Key key,
//   }) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//      final streamChat = StreamChannel.of(context);
//     return CupertinoNavigationBar(
//       middle: Column(
//         children: [
//           CupertinoCircleAvatar(
//               size: 25, url: streamChat.channel.extraData['image'] as String),
//           Expanded(child: Text(streamChat.channel.extraData['name'] as String))
//         ],
//       ),
//     );
//   }
// }
