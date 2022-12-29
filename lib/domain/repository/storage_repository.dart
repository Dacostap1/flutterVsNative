import 'dart:io';

abstract class StorageRepository {
  Future<Map<String, dynamic>> uploadImage({
    required File image,
    required String imageName,
    required String doctorName,
  });

  Future<void> deletePhoto(String path);
}
