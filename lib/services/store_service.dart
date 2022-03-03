import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "post_images";

  static Future<String?> uploadImage(File? image) async {
    if(image==null) return null;
    String imgName = "image_" + DateTime.now().toString();
    Reference firebaseStorageRef = _storage.child(folder).child(imgName);
    UploadTask uploadTask = firebaseStorageRef.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
