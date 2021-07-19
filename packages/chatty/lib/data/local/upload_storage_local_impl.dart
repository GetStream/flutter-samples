import 'dart:io';

import 'package:stream_chatter/data/upload_storage_repository.dart';

class UploadStorageLocalImpl extends UploadStorageRepository {
  @override
  Future<String> uploadPhoto(File? file, String path) async {
    return 'https://lh3.googleusercontent.com/a-/AOh14GjhqGZ-V7tNXS1pOIp9vbBij4OS9JbzxXgxgy1t=s600-k-no-rp-mo';
  }
}
