import 'dart:io';

import 'package:stream_chatter/data/auth_repository.dart';
import 'package:stream_chatter/data/stream_api_repository.dart';
import 'package:stream_chatter/data/upload_storage_repository.dart';
import 'package:stream_chatter/domain/models/chat_user.dart';

class ProfileInput {
  ProfileInput({this.imageFile, this.name});
  final File imageFile;
  final String name;
}

class ProfileSignInUseCase {
  ProfileSignInUseCase(
    this._authRepository,
    this._streamApiRepository,
    this._uploadStorageRepository,
  );

  final AuthRepository _authRepository;
  final UploadStorageRepository _uploadStorageRepository;
  final StreamApiRepository _streamApiRepository;

  Future<void> verify(ProfileInput input) async {
    final auth = await _authRepository.getAuthUser();
    final token = await _streamApiRepository.getToken(auth.id);
    String image;
    if (input.imageFile != null) {
      image = await _uploadStorageRepository.uploadPhoto(input.imageFile, 'users/${auth.id}');
    }
    await _streamApiRepository.connectUser(ChatUser(name: input.name, id: auth.id, image: image), token);
  }
}
