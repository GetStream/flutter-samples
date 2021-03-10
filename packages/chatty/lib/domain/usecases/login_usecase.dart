import 'package:stream_chatter/data/auth_repository.dart';
import 'package:stream_chatter/data/stream_api_repository.dart';
import 'package:stream_chatter/domain/exceptions/auth_exception.dart';
import 'package:stream_chatter/domain/models/auth_user.dart';

class LoginUseCase {
  LoginUseCase(this.authRepository, this.streamApiRepository);

  final AuthRepository authRepository;
  final StreamApiRepository streamApiRepository;

  Future<bool> validateLogin() async {
    print('validateLogin');
    final user = await authRepository.getAuthUser();
    print('user: ${user?.id}');
    if (user != null) {
      final result = await streamApiRepository.connectIfExist(user.id);
      if (result) {
        return true;
      } else {
        throw AuthException(AuthErrorCode.not_chat_user);
      }
    }
    throw AuthException(AuthErrorCode.not_auth);
  }

  Future<AuthUser> signIn() async {
    return await authRepository.signIn();
  }
}
