import 'package:stream_chatter/data/auth_repository.dart';
import 'package:stream_chatter/data/image_picker_repository.dart';
import 'package:stream_chatter/data/local/image_picker_impl.dart';
import 'package:stream_chatter/data/persistent_storage_repository.dart';
import 'package:stream_chatter/data/prod/auth_impl.dart';
import 'package:stream_chatter/data/prod/persistent_storage_impl.dart';
import 'package:stream_chatter/data/prod/stream_api_impl.dart';
import 'package:stream_chatter/data/prod/upload_storage_impl.dart';
import 'package:stream_chatter/data/stream_api_repository.dart';
import 'package:stream_chatter/data/upload_storage_repository.dart';
import 'package:stream_chatter/domain/usecases/create_group_usecase.dart';
import 'package:stream_chatter/domain/usecases/login_usecase.dart';
import 'package:stream_chatter/domain/usecases/logout_usecase.dart';
import 'package:stream_chatter/domain/usecases/profile_sign_in_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

List<RepositoryProvider> buildRepositories(StreamChatClient client) {
  //TODO: Here you can use your local implementations of your repositories
  return [
    RepositoryProvider<StreamApiRepository>(
        create: (_) => StreamApiImpl(client)),
    RepositoryProvider<PersistentStorageRepository>(
        create: (_) => PersistentStorageImpl()),
    RepositoryProvider<AuthRepository>(create: (_) => AuthImpl()),
    RepositoryProvider<UploadStorageRepository>(
        create: (_) => UploadStorageImpl()),
    RepositoryProvider<ImagePickerRepository>(create: (_) => ImagePickerImpl()),
    RepositoryProvider<ProfileSignInUseCase>(
      create: (context) => ProfileSignInUseCase(
        context.read(),
        context.read(),
        context.read(),
      ),
    ),
    RepositoryProvider<CreateGroupUseCase>(
      create: (context) => CreateGroupUseCase(
        context.read(),
        context.read(),
      ),
    ),
    RepositoryProvider<LogoutUseCase>(
      create: (context) => LogoutUseCase(
        context.read(),
        context.read(),
      ),
    ),
    RepositoryProvider<LoginUseCase>(
      create: (context) => LoginUseCase(
        context.read(),
        context.read(),
      ),
    ),
  ];
}
