import 'dart:io';

abstract class StorageRepository {
  Future<Map<String, dynamic>> uploadImage({
    required File image,
    required String imageName,
  });

  Future<void> deleteImage(String path);
}
