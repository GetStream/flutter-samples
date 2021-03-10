import 'package:stream_chatter/data/persistent_storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppThemeCubit extends Cubit<bool> {
  AppThemeCubit(this._persistentStorageRepository) : super(false);
  final PersistentStorageRepository _persistentStorageRepository;

  bool _isDark = false;
  bool get isDark => _isDark;

  Future<void> init() async {
    _isDark = await _persistentStorageRepository.isDarkMode();
    emit(_isDark);
  }

  Future<void> updateTheme(bool isDarkMode) async {
    _isDark = isDarkMode;
    await _persistentStorageRepository.updateDarkMode(isDarkMode);
    emit(_isDark);
  }
}
