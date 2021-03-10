import 'package:stream_chatter/domain/usecases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsSwitchCubit extends Cubit<bool> {
  SettingsSwitchCubit(bool state) : super(state);

  void onChangeDarkMode(bool isDark) => emit(isDark);
}

class SettingsLogoutCubit extends Cubit<void> {
  SettingsLogoutCubit(this._logoutUseCase) : super(null);

  final LogoutUseCase _logoutUseCase;

  void logOut() async {
    await _logoutUseCase.logout();
    emit(null);
  }
}
