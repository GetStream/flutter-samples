import 'package:example/app/api_data.dart';
import 'package:example/app/chat_client.dart';
import 'package:example/app/init_data.dart';
import 'package:example/app/localizations.dart';
import 'package:example/app/routes/app_routes.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/app/splash_screen.dart';
import 'package:example/screens/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ChatAppV1 extends StatefulWidget {
  @override
  State<ChatAppV1> createState() => _ChatAppV1State();
}

class _ChatAppV1State extends State<ChatAppV1>
    with SplashScreenStateMixin, TickerProviderStateMixin {
  InitData? _initData;

  Future<InitData> _initConnection() async {
    String? apiKey, userId, token;

    if (!kIsWeb) {
      final secureStorage = FlutterSecureStorage();
      apiKey = await secureStorage.read(key: kStreamApiKey);
      userId = await secureStorage.read(key: kStreamUserId);
      token = await secureStorage.read(key: kStreamToken);
    }

    final client = buildStreamChatClient(apiKey ?? kStreamApiKey);

    if (userId != null && token != null) {
      await client.connectUser(
        User(id: userId),
        token,
      );
    }

    final prefs = await StreamingSharedPreferences.instance;

    return InitData(client, prefs);
  }

  @override
  void initState() {
    super.initState();

    final timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _initConnection().then(
      (initData) {
        setState(() => _initData = initData);

        final now = DateTime.now().millisecondsSinceEpoch;

        if (now - timeOfStartMs > 1500) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            forwardAnimations();
          });
        } else {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            forwardAnimations();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_initData != null)
          PreferenceBuilder<int>(
            preference: _initData!.preferences.getInt(
              'theme',
              defaultValue: 0,
            ),
            builder: (context, snapshot) => MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: {
                -1: ThemeMode.dark,
                0: ThemeMode.system,
                1: ThemeMode.light,
              }[snapshot],
              supportedLocales: const [
                Locale('en'),
                Locale('it'),
              ],
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalStreamChatLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              builder: (context, child) => StreamChatTheme(
                data: StreamChatThemeData(
                  brightness: Theme.of(context).brightness,
                ),
                child: child!,
              ),
              onGenerateRoute: AppRoutes.generateRoute,
              onGenerateInitialRoutes: (initialRouteName) {
                if (initialRouteName == Routes.HOME) {
                  return [
                    AppRoutes.generateRoute(
                      RouteSettings(
                        name: Routes.HOME,
                        arguments: HomePageArgs(_initData!.client),
                      ),
                    )!
                  ];
                }
                return [
                  AppRoutes.generateRoute(
                    RouteSettings(
                      name: Routes.CHOOSE_USER,
                    ),
                  )!
                ];
              },
              initialRoute: _initData!.client.state.currentUser == null
                  ? Routes.CHOOSE_USER
                  : Routes.HOME,
            ),
          ),
        if (!animationCompleted) buildAnimation(),
      ],
    );
  }
}
