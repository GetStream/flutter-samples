import 'dart:async';

import 'package:example/app/localizations.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/screens/user_mentions_page.dart';
import 'package:example/widgets/channel_list.dart';
import 'package:example/widgets/left_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  _ChannelListPageState createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  int _currentIndex = 0;

  bool _isSelected(int index) => _currentIndex == index;

  List<BottomNavigationBarItem> get _navBarItems {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.message(
              color: _isSelected(0)
                  ? StreamChatTheme.of(context).colorTheme.textHighEmphasis
                  : Colors.grey,
            ),
            Positioned(
              top: -3,
              right: -16,
              child: StreamUnreadIndicator(),
            ),
          ],
        ),
        label: AppLocalizations.of(context).chats,
      ),
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.mentions(
              color: _isSelected(1)
                  ? StreamChatTheme.of(context).colorTheme.textHighEmphasis
                  : Colors.grey,
            ),
          ],
        ),
        label: AppLocalizations.of(context).mentions,
      ),
    ];
  }

  StreamSubscription<int>? badgeListener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      badgeListener = StreamChat.of(context)
          .client
          .state
          .totalUnreadCountStream
          .listen((count) {
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      });
    }
  }

  @override
  void dispose() {
    badgeListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser;
    if (user == null) {
      return Offstage();
    }
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamChannelListHeader(
        onNewChatButtonTap: () {
          Navigator.of(context).pushNamed(Routes.NEW_CHAT);
        },
        preNavigationCallback: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
      drawer: LeftDrawer(
        user: user,
      ),
      drawerEdgeDragWidth: 50,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
        currentIndex: _currentIndex,
        items: _navBarItems,
        selectedLabelStyle: StreamChatTheme.of(context).textTheme.footnoteBold,
        unselectedLabelStyle:
            StreamChatTheme.of(context).textTheme.footnoteBold,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            StreamChatTheme.of(context).colorTheme.textHighEmphasis,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ChannelList(),
          UserMentionsPage(),
        ],
      ),
    );
  }
}
