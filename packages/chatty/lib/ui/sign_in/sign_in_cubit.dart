import 'package:stream_chatter/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SignInState {
  none,
  existing_user,
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._loginUseCase,
  ) : super(SignInState.none);

  final LoginUseCase _loginUseCase;

  void signIn() async {
    try {
      final result = await _loginUseCase.validateLogin();
      if (result) {
        emit(SignInState.existing_user);
      }
    } catch (ex) {
      _loginUseCase.signIn();
      emit(SignInState.none);
    }
  }
}
