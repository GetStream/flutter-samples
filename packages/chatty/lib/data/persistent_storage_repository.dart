abstract class PersistentStorageRepository {
  Future<bool> isDarkMode();
  Future<void> updateDarkMode(bool isDarkMode);
}
