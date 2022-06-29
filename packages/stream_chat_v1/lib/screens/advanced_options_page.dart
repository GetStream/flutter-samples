import 'package:example/app/api_data.dart';
import 'package:example/app/chat_client.dart';
import 'package:example/app/localizations.dart';
import 'package:example/app/routes/routes.dart';
import 'package:example/screens/home_page.dart';
import 'package:example/widgets/stream_version.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AdvancedOptionsPage extends StatefulWidget {
  const AdvancedOptionsPage({Key? key}) : super(key: key);

  @override
  State<AdvancedOptionsPage> createState() => _AdvancedOptionsPageState();
}

class _AdvancedOptionsPageState extends State<AdvancedOptionsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _apiKeyController = TextEditingController();
  String? _apiKeyError;

  final TextEditingController _userIdController = TextEditingController();
  String? _userIdError;

  final TextEditingController _userTokenController = TextEditingController();
  String? _userTokenError;

  final TextEditingController _usernameController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final streamChatTheme = StreamChatTheme.of(context);
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: streamChatTheme.colorTheme.appBg,
      appBar: AppBar(
        backgroundColor: streamChatTheme.colorTheme.barsBg,
        elevation: 1,
        centerTitle: true,
        title: Text(
          appLocalizations.advancedOptions,
          style: streamChatTheme.textTheme.headlineBold.copyWith(
            color: streamChatTheme.colorTheme.textHighEmphasis,
          ),
        ),
        leading: IconButton(
          icon: StreamSvgIcon.left(
            color: streamChatTheme.colorTheme.textHighEmphasis,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _apiKeyController,
                    onChanged: (_) {
                      if (_apiKeyError != null) {
                        setState(() => _apiKeyError = null);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _apiKeyError =
                              appLocalizations.apiKeyError.toUpperCase();
                        });
                        return _apiKeyError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: streamChatTheme.colorTheme.textHighEmphasis,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _apiKeyError != null
                            ? streamChatTheme.colorTheme.accentError
                            : streamChatTheme.colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: streamChatTheme.colorTheme.inputBg,
                      filled: true,
                      labelText: _apiKeyError != null
                          ? '${appLocalizations.chatApiKey.toUpperCase()}: $_apiKeyError'
                          : appLocalizations.chatApiKey,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _userIdController,
                    onChanged: (_) {
                      if (_userIdError != null) {
                        setState(() => _userIdError = null);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _userIdError =
                              appLocalizations.userIdError.toUpperCase();
                        });
                        return _userIdError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: streamChatTheme.colorTheme.textHighEmphasis,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userIdError != null
                            ? streamChatTheme.colorTheme.accentError
                            : streamChatTheme.colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: streamChatTheme.colorTheme.inputBg,
                      filled: true,
                      labelText: _userIdError != null
                          ? '${appLocalizations.userId.toUpperCase()}: $_userIdError'
                          : appLocalizations.userId,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    onChanged: (_) {
                      if (_userTokenError != null) {
                        setState(() => _userTokenError = null);
                      }
                    },
                    controller: _userTokenController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _userTokenError =
                              appLocalizations.userTokenError.toUpperCase();
                        });
                        return _userTokenError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: streamChatTheme.colorTheme.textHighEmphasis,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(height: 0, fontSize: 0),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: _userTokenError != null
                            ? streamChatTheme.colorTheme.accentError
                            : streamChatTheme.colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: streamChatTheme.colorTheme.inputBg,
                      filled: true,
                      labelText: _userTokenError != null
                          ? '${appLocalizations.userToken.toUpperCase()}: $_userTokenError'
                          : appLocalizations.userToken,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: streamChatTheme.colorTheme.textLowEmphasis,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: streamChatTheme.colorTheme.inputBg,
                      filled: true,
                      labelText: appLocalizations.usernameOptional,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          materialTheme.brightness == Brightness.light
                              ? streamChatTheme.colorTheme.accentPrimary
                              : Colors.white),
                      elevation: MaterialStateProperty.all<double>(0),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(vertical: 16)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                    ),
                    child: Text(
                      appLocalizations.login,
                      style: TextStyle(
                        fontSize: 16,
                        color: materialTheme.brightness != Brightness.light
                            ? streamChatTheme.colorTheme.accentPrimary
                            : Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (loading) {
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        final apiKey = _apiKeyController.text;
                        final userId = _userIdController.text;
                        final userToken = _userTokenController.text;
                        final username = _usernameController.text;

                        loading = true;
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          barrierColor: streamChatTheme.colorTheme.overlay,
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

                        final client = buildStreamChatClient(apiKey);

                        try {
                          await client.connectUser(
                            User(
                              id: userId,
                              extraData: {
                                'name': username,
                              },
                            ),
                            userToken,
                          );

                          final secureStorage = FlutterSecureStorage();
                          secureStorage.write(
                            key: kStreamApiKey,
                            value: apiKey,
                          );
                          secureStorage.write(
                            key: kStreamUserId,
                            value: userId,
                          );
                          secureStorage.write(
                            key: kStreamToken,
                            value: userToken,
                          );
                        } catch (e) {
                          var errorText = appLocalizations.errorConnecting;
                          if (e is Map) {
                            errorText = e['message'] ?? errorText;
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            _apiKeyError = errorText.toUpperCase();
                          });
                          loading = false;
                          return;
                        }
                        loading = false;
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.HOME,
                          ModalRoute.withName(Routes.HOME),
                          arguments: HomePageArgs(client),
                        );
                      }
                    },
                  ),
                  StreamVersion(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
