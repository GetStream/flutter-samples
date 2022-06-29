import 'package:example/app/api_data.dart';
import 'package:example/app/chat_client.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/app/app_config.dart';
import 'package:example/screens/home_page.dart';
import 'package:example/app/localizations.dart';
import 'package:example/widgets/stream_version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChooseUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = defaultUsers;
    final streamChatTheme = StreamChatTheme.of(context);
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: streamChatTheme.colorTheme.appBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 34,
                bottom: 20,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/logo.svg',
                  height: 40,
                  color: streamChatTheme.colorTheme.accentPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13.0),
              child: Text(
                appLocalizations.welcomeToStreamChat,
                style: streamChatTheme.textTheme.title,
              ),
            ),
            Text(
              '${appLocalizations.selectUserToTryFlutterSDK}:',
              style: streamChatTheme.textTheme.body,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ListView.separated(
                  separatorBuilder: (context, i) {
                    return Container(
                      height: 1,
                      color: streamChatTheme.colorTheme.borders,
                    );
                  },
                  itemCount: users.length + 1,
                  itemBuilder: (context, i) {
                    return [
                      ...users.entries.map(
                        (entry) {
                          final token = entry.key;
                          final user = entry.value;
                          return ListTile(
                            visualDensity: VisualDensity.compact,
                            onTap: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                barrierColor:
                                    streamChatTheme.colorTheme.overlay,
                                builder: (context) => Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: streamChatTheme.colorTheme.barsBg,
                                    ),
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              );

                              final client = StreamChatClient(
                                kDefaultStreamApiKey,
                                logLevel: Level.INFO,
                              )..chatPersistenceClient = chatPersistentClient;

                              await client.connectUser(
                                user,
                                token,
                              );

                              if (!kIsWeb) {
                                final secureStorage = FlutterSecureStorage();
                                secureStorage.write(
                                  key: kStreamApiKey,
                                  value: kDefaultStreamApiKey,
                                );
                                secureStorage.write(
                                  key: kStreamUserId,
                                  value: user.id,
                                );
                                secureStorage.write(
                                  key: kStreamToken,
                                  value: token,
                                );
                              }
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.HOME,
                                ModalRoute.withName(Routes.HOME),
                                arguments: HomePageArgs(client),
                              );
                            },
                            leading: StreamUserAvatar(
                              user: user,
                              constraints: BoxConstraints.tight(
                                Size.fromRadius(20),
                              ),
                            ),
                            title: Text(
                              user.name,
                              style: streamChatTheme.textTheme.bodyBold,
                            ),
                            subtitle: Text(
                              appLocalizations.streamTestAccount,
                              style:
                                  streamChatTheme.textTheme.footnote.copyWith(
                                color:
                                    streamChatTheme.colorTheme.textLowEmphasis,
                              ),
                            ),
                            trailing: StreamSvgIcon.arrowRight(
                              color: streamChatTheme.colorTheme.accentPrimary,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.ADVANCED_OPTIONS);
                        },
                        leading: CircleAvatar(
                          child: StreamSvgIcon.settings(
                            color: streamChatTheme.colorTheme.textHighEmphasis,
                          ),
                          backgroundColor: streamChatTheme.colorTheme.borders,
                        ),
                        title: Text(
                          appLocalizations.advancedOptions,
                          style: streamChatTheme.textTheme.bodyBold,
                        ),
                        subtitle: Text(
                          appLocalizations.customSettings,
                          style: streamChatTheme.textTheme.footnote.copyWith(
                            color: streamChatTheme.colorTheme.textLowEmphasis,
                          ),
                        ),
                        trailing: SvgPicture.asset(
                          'assets/icon_arrow_right.svg',
                          height: 24,
                          width: 24,
                          clipBehavior: Clip.none,
                        ),
                      ),
                    ][i];
                  },
                ),
              ),
            ),
            StreamVersion(),
          ],
        ),
      ),
    );
  }
}
