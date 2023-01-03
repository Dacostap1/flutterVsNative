import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_vs_native/domain/repository/storage_repository.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class StorageRepositoryImplementation implements StorageRepository {
  final _storage = FirebaseStorage.instance;

  @override
  Future<Map<String, dynamic>> uploadImage({
    required File image,
    required String imageName,
  }) async {
    //CREATE NAME UNIQUE TO NOT REPET
    const uuid = Uuid();
    final imagePath = 'images/${uuid.v1()}${extension(image.path)}';
    final ref = _storage.ref(imagePath);

    // Create your custom metadata.
    final custommetadata = SettableMetadata(
      customMetadata: <String, String>{
        'name': imageName,
      },
    );

    await ref.putFile(image, custommetadata);

    final map = {
      'image_url': await ref.getDownloadURL(),
      'image_name': '$imageName${extension(image.path)}'
    };

    return map;
  }

  @override
  Future<void> deleteImage(String path) async {
    print('path: $path');
    try {
      final ref = _storage.refFromURL(path);
      return await ref.delete();
    } on Exception catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
