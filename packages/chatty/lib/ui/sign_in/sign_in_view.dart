import 'package:stream_chatter/navigator_utils.dart';
import 'package:stream_chatter/ui/home/home_view.dart';
import 'package:stream_chatter/ui/profile_verify/profile_verify_view.dart';
import 'package:stream_chatter/ui/sign_in/sign_in_cubit.dart';
import 'package:stream_chatter/ui/common/initial_background_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(context.read()),
      child: BlocConsumer<SignInCubit, SignInState>(listener: (context, snapshot) {
        if (snapshot == SignInState.none) {
          pushAndReplaceToPage(context, ProfileVerifyView());
        } else {
          pushAndReplaceToPage(context, HomeView());
        }
      }, builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          body: Stack(children: [
            InitialBackgroundView(),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Hero(
                    tag: 'logo_hero',
                    child: Image.asset(
                      'assets/logo.png',
                      height: 50,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Welcome to\nChatty',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                    child: Text(
                      'A platform to chat with users very easily and friendly',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Material(
                    elevation: 2,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                    child: InkWell(
                      onTap: () {
                        context.read<SignInCubit>().signIn();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icon-google.png', height: 20),
                            const SizedBox(width: 15),
                            Text('Login with Google'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '"in the modern world the\nquality of life is the quality\nof communication',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }
}
