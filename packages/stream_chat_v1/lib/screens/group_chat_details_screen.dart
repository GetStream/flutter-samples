import 'package:example/app/localizations.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/screens/channel_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GroupChatDetailsScreen extends StatefulWidget {
  const GroupChatDetailsScreen({
    Key? key,
    required this.selectedUsers,
  }) : super(key: key);

  final List<User>? selectedUsers;

  @override
  State<GroupChatDetailsScreen> createState() => _GroupChatDetailsScreenState();
}

class _GroupChatDetailsScreenState extends State<GroupChatDetailsScreen> {
  final _selectedUsers = <User>[];

  TextEditingController? _groupNameController;

  bool _isGroupNameEmpty = true;

  int get _totalUsers => _selectedUsers.length;

  void _groupNameListener() {
    final name = _groupNameController!.text;
    if (mounted) {
      setState(() => _isGroupNameEmpty = name.isEmpty);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedUsers.addAll(widget.selectedUsers!);
    _groupNameController = TextEditingController()
      ..addListener(_groupNameListener);
  }

  @override
  void dispose() {
    _groupNameController?.removeListener(_groupNameListener);
    _groupNameController?.clear();
    _groupNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamChatTheme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_selectedUsers);
        return false;
      },
      child: Scaffold(
        backgroundColor: streamChatTheme.colorTheme.appBg,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: streamChatTheme.colorTheme.barsBg,
          leading: const StreamBackButton(),
          title: Text(
            appLocalizations.nameOfGroupChat,
            style: TextStyle(
              color: streamChatTheme.colorTheme.textHighEmphasis,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  Text(
                    appLocalizations.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: streamChatTheme.colorTheme.textLowEmphasis,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _groupNameController,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                        hintText: appLocalizations.chooseAGroupChatName,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: streamChatTheme.colorTheme.textLowEmphasis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            StreamNeumorphicButton(
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: StreamSvgIcon.check(
                  size: 24,
                  color: _isGroupNameEmpty
                      ? streamChatTheme.colorTheme.textLowEmphasis
                      : streamChatTheme.colorTheme.accentPrimary,
                ),
                onPressed: _isGroupNameEmpty
                    ? null
                    : () async {
                        try {
                          final groupName = _groupNameController!.text;
                          final client = StreamChat.of(context).client;
                          final channel = client.channel('messaging',
                              id: Uuid().v4(),
                              extraData: {
                                'members': [
                                  client.state.currentUser!.id,
                                  ..._selectedUsers.map((e) => e.id),
                                ],
                                'name': groupName,
                              });
                          await channel.watch();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.CHANNEL_PAGE,
                            ModalRoute.withName(Routes.CHANNEL_LIST_PAGE),
                            arguments: ChannelPageArgs(channel: channel),
                          );
                        } catch (err) {
                          _showErrorAlert();
                        }
                      },
              ),
            ),
          ],
        ),
        body: StreamConnectionStatusBuilder(
          statusBuilder: (context, status) {
            String statusString = '';
            bool showStatus = true;

            switch (status) {
              case ConnectionStatus.connected:
                statusString = appLocalizations.connected;
                showStatus = false;
                break;
              case ConnectionStatus.connecting:
                statusString = appLocalizations.reconnecting;
                break;
              case ConnectionStatus.disconnected:
                statusString = appLocalizations.disconnected;
                break;
            }
            return StreamInfoTile(
              showMessage: showStatus,
              tileAnchor: Alignment.topCenter,
              childAnchor: Alignment.topCenter,
              message: statusString,
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      gradient: streamChatTheme.colorTheme.bgGradient,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Text(
                        '$_totalUsers ${_totalUsers > 1 ? appLocalizations.members : appLocalizations.member}',
                        style: TextStyle(
                          color: streamChatTheme.colorTheme.textLowEmphasis,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanDown: (_) => FocusScope.of(context).unfocus(),
                      child: ListView.separated(
                        itemCount: _selectedUsers.length + 1,
                        separatorBuilder: (_, __) => Container(
                          height: 1,
                          color: streamChatTheme.colorTheme.borders,
                        ),
                        itemBuilder: (_, index) {
                          if (index == _selectedUsers.length) {
                            return Container(
                              height: 1,
                              color: streamChatTheme.colorTheme.borders,
                            );
                          }
                          final user = _selectedUsers[index];
                          return ListTile(
                            key: ObjectKey(user),
                            leading: StreamUserAvatar(
                              user: user,
                              constraints: BoxConstraints.tightFor(
                                width: 40,
                                height: 40,
                              ),
                            ),
                            title: Text(
                              user.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                color:
                                    streamChatTheme.colorTheme.textHighEmphasis,
                              ),
                              padding: const EdgeInsets.all(0),
                              splashRadius: 24,
                              onPressed: () {
                                setState(() => _selectedUsers.remove(user));
                                if (_selectedUsers.isEmpty) {
                                  Navigator.of(context).pop(_selectedUsers);
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showErrorAlert() {
    final streamChatTheme = StreamChatTheme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    showModalBottomSheet(
      useRootNavigator: false,
      backgroundColor: streamChatTheme.colorTheme.barsBg,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 26.0),
            StreamSvgIcon.error(
              color: streamChatTheme.colorTheme.accentError,
              size: 24.0,
            ),
            SizedBox(height: 26.0),
            Text(
              appLocalizations.somethingWentWrongErrorMessage,
              style: streamChatTheme.textTheme.headlineBold,
            ),
            SizedBox(height: 7.0),
            Text(appLocalizations.operationCouldNotBeCompleted),
            SizedBox(height: 36.0),
            Container(
              color:
                  streamChatTheme.colorTheme.textHighEmphasis.withOpacity(.08),
              height: 1.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    appLocalizations.ok,
                    style: streamChatTheme.textTheme.bodyBold.copyWith(
                        color: streamChatTheme.colorTheme.accentPrimary),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
