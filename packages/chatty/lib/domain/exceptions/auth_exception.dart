enum AuthErrorCode {
  not_auth,
  not_chat_user,
}

class AuthException implements Exception {
  AuthException(this.error);

  final AuthErrorCode error;
}
