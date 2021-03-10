import 'dart:io';

abstract class UploadStorageRepository {
  Future<String> uploadPhoto(File file, String path);
}
