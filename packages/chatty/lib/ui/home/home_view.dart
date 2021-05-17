import 'package:stream_chatter/navigator_utils.dart';
import 'package:stream_chatter/ui/home/chat/chat_view.dart';
import 'package:stream_chatter/ui/home/chat/selection/friends_selection_view.dart';
import 'package:stream_chatter/ui/home/home_cubit.dart';
import 'package:stream_chatter/ui/home/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider(
        create: (_) => HomeCubit(),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<HomeCubit, int>(builder: (context, snapshot) {
                return IndexedStack(
                  index: snapshot,
                  children: [
                    ChatView(),
                    SettingsView(),
                  ],
                );
              }),
            ),
            HomeNavigationBar(),
          ],
        ),
      ),
    );
  }
}

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context, listen: true);
    final navigationBarSize = 80.0;
    final buttonSize = 56.0;
    final buttonMargin = 4.0;
    final topMargin = buttonSize / 2 + buttonMargin / 2;
    final canvasColor = Theme.of(context).canvasColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        child: Container(
          height: navigationBarSize + topMargin,
          width: MediaQuery.of(context).size.width * 0.7,
          color: canvasColor,
          child: Stack(
            children: [
              Positioned.fill(
                top: topMargin,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HomeNavItem(
                        text: 'Chats',
                        iconData: Icons.chat_bubble,
                        onTap: () => cubit.onChangeTab(0),
                        selected: cubit.state == 0,
                      ),
                      _HomeNavItem(
                        text: 'Settings',
                        iconData: Icons.settings,
                        onTap: () => cubit.onChangeTab(1),
                        selected: cubit.state == 1,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: canvasColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(buttonMargin / 2),
                  child: FloatingActionButton(
                    onPressed: () {
                      pushToPage(context, FriendsSelectionView());
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    Key key,
    this.iconData,
    this.text,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        Theme.of(context).bottomNavigationBarTheme.selectedItemColor;
    final unselectedColor =
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    final color = selected ? selectedColor : unselectedColor;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
