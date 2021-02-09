
import 'package:flutter/cupertino.dart';

class ChannelPageAppBar extends StatelessWidget {
  const ChannelPageAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text('Messages'),
    );
  }
}
