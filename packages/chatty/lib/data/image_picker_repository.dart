import 'dart:io';

abstract class ImagePickerRepository {
  Future<File?> pickImage();
}
