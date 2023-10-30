import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const int maxLines = 900000;
Future<String> get _localPath async {
  //Get external storage directory
  if(Platform.isIOS){ 
    return "";
  }
  var directory = await getExternalStorageDirectory();
  //Check if external storage not available. If not available use
  //internal applications directory
  directory ??= await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {



  final path = await _localPath;

  return File('$path/logs.txt');
}

Future write(String data) async {
if(Platform.isIOS){ 
  return;
}
  final file = await _localFile;
  if (!await file.exists()) {
    // Create the file if it does not exist
    await file.create();
  }
  final lines = await file.readAsLines();

  if (lines.length > maxLines) {
    // Clear the log file if it exceeds the maximum number of lines
    await file.writeAsString('');
  }

  log(data);
  // Write the file in append mode so it would append the data to
  //existing file
   return file.writeAsString('$data\n', mode: FileMode.append);
}
