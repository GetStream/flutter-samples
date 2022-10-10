import 'package:example/pages/channel_page.dart';
import 'package:example/utils/localizations.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void showLocalNotification(
  Event event,
  String currentUserId,
  BuildContext context,
) async {
  if (![
        EventType.messageNew,
        EventType.notificationMessageNew,
      ].contains(event.type) ||
      event.user!.id == currentUserId) {
    return;
  }
  if (event.message == null) return;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  final appLocalizations = AppLocalizations.of(context);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (channelCid) async {
      if (channelCid != null) {
        final client = StreamChat.of(context).client;
        final navigator = Navigator.of(context);

        var channel = client.state.channels[channelCid];

        if (channel == null) {
          final splits = channelCid.split(':');
          final type = splits[0];
          final id = splits[1];
          channel = client.channel(
            type,
            id: id,
          );
          await channel.watch();
        }

        navigator.pushNamed(
          Routes.CHANNEL_PAGE,
          arguments: ChannelPageArgs(
            channel: channel,
          ),
        );
      }
    },
  );
  await flutterLocalNotificationsPlugin.show(
    event.message!.id.hashCode,
    event.message!.user!.name,
    event.message!.text,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'message channel',
        appLocalizations.messageChannelName,
        channelDescription: appLocalizations.messageChannelDescription,
        priority: Priority.high,
        importance: Importance.high,
      ),
      iOS: const IOSNotificationDetails(),
    ),
    payload: '${event.channelType}:${event.channelId}',
  );
}