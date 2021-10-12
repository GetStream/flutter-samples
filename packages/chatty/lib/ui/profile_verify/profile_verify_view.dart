import 'package:stream_chatter/navigator_utils.dart';
import 'package:stream_chatter/ui/common/avatar_image_view.dart';
import 'package:stream_chatter/ui/common/loading_view.dart';
import 'package:stream_chatter/ui/home/home_view.dart';
import 'package:stream_chatter/ui/profile_verify/profile_verify_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileVerifyView extends StatelessWidget {
  ProfileVerifyView();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileVerifyCubit(context.read(), context.read()),
      child: BlocConsumer<ProfileVerifyCubit, ProfileState>(
          listener: (context, snapshot) {
        if (snapshot.success) {
          pushAndReplaceToPage(context, HomeView());
        }
      }, builder: (context, snapshot) {
        //refresh the photo
        return LoadingView(
          isLoading: snapshot.loading,
          child: Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify your identity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AvatarImageView(
                    onTap: context.read<ProfileVerifyCubit>().pickImage,
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
                  Text(
                    'Your name',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 20,
                    ),
                    child: TextField(
                      controller:
                          context.read<ProfileVerifyCubit>().nameController,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context)
                            .bottomNavigationBarTheme
                            .backgroundColor,
                        hintText: 'Or just how people now you',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'home_hero',
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      child: InkWell(
                          onTap: () {
                            context.read<ProfileVerifyCubit>().startChatting();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 15,
                            ),
                            child: Text(
                              'Start chatting now',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
