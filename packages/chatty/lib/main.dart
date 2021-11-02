import 'package:firebase_core/firebase_core.dart';
import 'package:stream_chatter/dependencies.dart';
import 'package:stream_chatter/ui/app_theme_cubit.dart';
import 'package:stream_chatter/ui/splash/splash_view.dart';
import 'package:stream_chatter/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _streamChatClient = StreamChatClient('c2rynysx9x6b');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    return MultiRepositoryProvider(
      providers: buildRepositories(_streamChatClient),
      child: BlocProvider(
        create: (context) => AppThemeCubit(context.read())..init(),
        child: BlocBuilder<AppThemeCubit, bool>(builder: (context, snapshot) {
          return MaterialApp(
            title: 'Stream Chatty',
            home: SplashView(),
            theme: snapshot ? Themes.themeDark : Themes.themeLight,
            builder: (context, child) {
              return StreamChat(
                child: child,
                client: _streamChatClient,
                streamChatThemeData:
                    StreamChatThemeData.fromTheme(Theme.of(context)).copyWith(
                  ownMessageTheme: MessageThemeData(
                    messageBackgroundColor:
                        Theme.of(context).colorScheme.secondary,
                    messageTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
