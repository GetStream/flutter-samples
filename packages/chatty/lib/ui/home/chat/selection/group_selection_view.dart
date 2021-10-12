import 'package:stream_chatter/navigator_utils.dart';
import 'package:stream_chatter/ui/common/avatar_image_view.dart';
import 'package:stream_chatter/ui/common/loading_view.dart';
import 'package:stream_chatter/ui/home/chat/chat_view.dart';
import 'package:stream_chatter/ui/home/chat/selection/friends_selection_cubit.dart';
import 'package:stream_chatter/ui/home/chat/selection/group_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GroupSelectionView extends StatelessWidget {
  GroupSelectionView(this.selectedUsers);

  final List<ChatUserState> selectedUsers;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupSelectionCubit(
        selectedUsers,
        context.read(),
        context.read(),
      ),
      child: BlocConsumer<GroupSelectionCubit, GroupSelectionState>(
          listener: (context, snapshot) {
        if (snapshot.channel != null) {
          pushAndReplaceToPage(
            context,
            Scaffold(
              body: StreamChannel(
                channel: snapshot.channel!,
                child: ChannelPage(),
              ),
            ),
          );
        }
      }, builder: (context, snapshot) {
        return LoadingView(
          isLoading: snapshot.isLoading,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.arrow_right_alt_rounded),
              onPressed: context.read<GroupSelectionCubit>().createGroup,
            ),
            backgroundColor: Theme.of(context).canvasColor,
            appBar: AppBar(
              title: Text(
                'New Group',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: Theme.of(context).canvasColor,
            ),
            body: Column(
              children: [
                AvatarImageView(
                  onTap: context.read<GroupSelectionCubit>().pickImage,
                  child: snapshot.file != null
                      ? Image.file(
                          snapshot.file!,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person_outline,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 20,
                  ),
                  child: TextField(
                    controller:
                        context.read<GroupSelectionCubit>().nameTextController,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      hintText: 'Name of the group',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                Wrap(
                  children: List.generate(selectedUsers.length, (index) {
                    final chatUserState = selectedUsers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(chatUserState.chatUser.image!),
                          ),
                          Text(chatUserState.chatUser.name!),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
