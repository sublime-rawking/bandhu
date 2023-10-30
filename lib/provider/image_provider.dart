import 'package:bandhu/provider/imagecropper.dart';
import 'package:bandhu/utils/log.dart';
import 'package:image_picker/image_picker.dart';

Future<void> takeImages({
  required Function storeImage,
  required ImageSource source,
}) async {
  try {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 40,
    );
    if (pickedImage == null) return;
    String croppedFile = await Cropper().userImage(pickedFile: pickedImage);
    if (croppedFile.isEmpty) return;
    await storeImage(croppedFile);
  } catch (e) {
    // Handle the exception
    write(e.toString());
  }
}
