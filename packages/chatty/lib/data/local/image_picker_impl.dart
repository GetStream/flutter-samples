import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chatter/data/image_picker_repository.dart';

class ImagePickerImpl extends ImagePickerRepository {
  @override
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );

    if (pickedFile == null) {
      return null;
    }

    return File(pickedFile.path);
  }
}
