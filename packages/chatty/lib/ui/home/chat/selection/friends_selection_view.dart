import 'package:stream_chatter/navigator_utils.dart';
import 'package:stream_chatter/ui/home/chat/chat_view.dart';
import 'package:stream_chatter/ui/home/chat/selection/friends_selection_cubit.dart';
import 'package:stream_chatter/ui/home/chat/selection/group_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FriendsSelectionView extends StatelessWidget {
  void _createFriendChannel(BuildContext context, ChatUserState chatUserState) async {
    final channel = await context.read<FriendsSelectionCubit>().createFriendChannel(chatUserState);
    pushAndReplaceToPage(
      context,
      Scaffold(
        body: StreamChannel(
          channel: channel,
          child: ChannelPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).appBarTheme.color;
    final accentColor = Theme.of(context).accentColor;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FriendsSelectionCubit(context.read())..init()),
        BlocProvider(create: (_) => FriendsGroupCubit()),
      ],
      child: BlocBuilder<FriendsGroupCubit, bool>(builder: (context, isGroup) {
        return BlocBuilder<FriendsSelectionCubit, List<ChatUserState>>(builder: (context, snapshot) {
          final selectedUsers = context.read<FriendsSelectionCubit>().selectedUsers;

          return Scaffold(
            floatingActionButton: isGroup && selectedUsers.isNotEmpty
                ? FloatingActionButton(
                    child: Icon(Icons.arrow_right_alt_rounded),
                    onPressed: () {
                      pushAndReplaceToPage(context, GroupSelectionView(selectedUsers));
                    })
                : null,
            backgroundColor: Theme.of(context).canvasColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isGroup)
                    Row(
                      children: [
                        BackButton(
                          onPressed: () {
                            context.read<FriendsGroupCubit>().changeToGroup();
                          },
                        ),
                        Text(
                          'New Group',
                          style: TextStyle(
                            fontSize: 24,
                            color: textColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        BackButton(
                          onPressed: Navigator.of(context).pop,
                        ),
                        Text(
                          'People',
                          style: TextStyle(
                            fontSize: 24,
                            color: textColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  if (!isGroup)
                    ListTile(
                      onTap: context.read<FriendsGroupCubit>().changeToGroup,
                      leading: CircleAvatar(
                        backgroundColor: accentColor,
                        child: Icon(Icons.group_outlined),
                      ),
                      title: Text('Create group', style: TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('Talk with 2 or more contacts'),
                    )
                  else if (isGroup && selectedUsers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 20.0, bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[200],
                          ),
                          Text(
                            'Add a friend',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                        height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedUsers.length,
                            itemBuilder: (context, index) {
                              final chatUserState = selectedUsers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(chatUserState.chatUser.image),
                                        ),
                                        Text(chatUserState.chatUser.name),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: 40,
                                      right: -4,
                                      child: InkWell(
                                        onTap: () => context.read<FriendsSelectionCubit>().selectUser(chatUserState),
                                        child: CircleAvatar(
                                          radius: 9,
                                          backgroundColor: accentColor,
                                          child: Icon(Icons.close_rounded, size: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.length,
                      itemBuilder: (context, index) {
                        final chatUserState = snapshot[index];
                        return ListTile(
                          onTap: () {
                            _createFriendChannel(context, chatUserState);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(chatUserState.chatUser.image),
                          ),
                          title: Text(chatUserState.chatUser.name),
                          trailing: isGroup
                              ? Checkbox(
                                  value: chatUserState.selected,
                                  onChanged: (val) {
                                    print('select user for group');
                                    context.read<FriendsSelectionCubit>().selectUser(chatUserState);
                                  },
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
