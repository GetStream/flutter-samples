import 'package:example/app/localizations.dart';
import 'package:example/app/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamChatTheme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    return Drawer(
      child: Container(
        color: streamChatTheme.colorTheme.barsBg,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 8,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      StreamUserAvatar(
                        user: user,
                        showOnlineStatus: false,
                        constraints: BoxConstraints.tight(Size.fromRadius(20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: StreamSvgIcon.penWrite(
                    color: streamChatTheme.colorTheme.textHighEmphasis
                        .withOpacity(.5),
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(Routes.NEW_CHAT);
                  },
                  title: Text(
                    appLocalizations.newDirectMessage,
                    style: TextStyle(fontSize: 14.5),
                  ),
                ),
                ListTile(
                  leading: StreamSvgIcon.contacts(
                    color: streamChatTheme.colorTheme.textHighEmphasis
                        .withOpacity(.5),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .popAndPushNamed(Routes.NEW_GROUP_CHAT);
                  },
                  title: Text(
                    appLocalizations.newGroup,
                    style: TextStyle(fontSize: 14.5),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      onTap: () async {
                        Navigator.of(context).pop();

                        if (!kIsWeb) {
                          final secureStorage = FlutterSecureStorage();
                          await secureStorage.deleteAll();
                        }

                        final client = StreamChat.of(context).client;
                        client.disconnectUser();
                        await client.dispose();

                        await Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          Routes.CHOOSE_USER,
                          ModalRoute.withName(Routes.CHOOSE_USER),
                        );
                      },
                      leading: StreamSvgIcon.user(
                        color: streamChatTheme.colorTheme.textHighEmphasis
                            .withOpacity(.5),
                      ),
                      title: Text(
                        appLocalizations.signOut,
                        style: TextStyle(
                          fontSize: 14.5,
                        ),
                      ),
                      trailing: IconButton(
                        icon: StreamSvgIcon.iconMoon(
                          size: 24,
                        ),
                        color: streamChatTheme.colorTheme.textLowEmphasis,
                        onPressed: () async {
                          final sp = await StreamingSharedPreferences.instance;
                          sp.setInt(
                            'theme',
                            Theme.of(context).brightness == Brightness.dark
                                ? 1
                                : -1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
