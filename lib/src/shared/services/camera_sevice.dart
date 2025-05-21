import 'dart:io';
import 'package:expense_mate/src/shared/services/database_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image != null ? File(image.path) : null;
  }

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<void> captureAndSaveProfilePictureCamera() async {
    final imageFile = await pickImageFromCamera();
    if (imageFile != null) {
      final permanentFile = await _saveToPersistentStorage(imageFile);
      await DatabaseService.instance.addOrUpdateProfilePicture(
        permanentFile.path,
      );
    }
  }

  Future<void> captureAndSaveProfilePictureGallery() async {
    final imageFile = await pickImageFromGallery();
    if (imageFile != null) {
      final permanentFile = await _saveToPersistentStorage(imageFile);
      await DatabaseService.instance.addOrUpdateProfilePicture(
        permanentFile.path,
      );
    }
  }

  Future<File> _saveToPersistentStorage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final newPath = path.join(directory.path, fileName);
    return imageFile.copy(newPath);
  }
}
