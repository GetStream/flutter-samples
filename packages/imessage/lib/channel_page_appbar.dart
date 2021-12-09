import 'package:flutter/cupertino.dart';

class ChannelPageAppBar extends StatelessWidget {
  const ChannelPageAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoSliverNavigationBar(
      largeTitle: Text(
        'Messages',
        style: TextStyle(letterSpacing: -1.3),
      ),
    );
  }
}
