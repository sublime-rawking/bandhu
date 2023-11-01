import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<String> pickPDFProvider() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowedExtensions: ["pdf"], type: FileType.custom);

  if (result != null) {
    File file = File(result.files.single.path.toString());
    return file.path;
  }
  return '';
}
