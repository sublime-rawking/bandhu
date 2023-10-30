import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Cropper {
  // Crop the selected image
  Future<CroppedFile?> cropImage({
    required XFile pickedFile,
  }) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 40,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          activeControlsWidgetColor: colorPrimary,
          toolbarColor: colorPrimary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          hideBottomControls: false,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    return croppedFile;
  }

  // Crop the selected image as a circle
  Future<String> userImage({
    required XFile pickedFile,
  }) async {
    final croppedFile = await ImageCropper().cropImage(
      aspectRatioPresets: [CropAspectRatioPreset.original],
      cropStyle: CropStyle.circle,
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          activeControlsWidgetColor: colorPrimary,
          toolbarColor: colorPrimary,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    return croppedFile?.path ?? '';
  }
}
