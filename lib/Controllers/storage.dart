import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String?> uploadImage(String path, BuildContext context) async {
    File file = File(path);
    try {
      String fileName = DateTime.now().toString();
      Reference ref = _storage.ref().child("images/$fileName");

      UploadTask uploadTask = ref.putFile(file);
      await uploadTask;

      String downloadURL = await ref.getDownloadURL();
      print("Download URL:$downloadURL");
      return downloadURL;
    } catch (e) {
      print('error');
      print(e);
      return null;
    }
  }
}

//===============================================/////////////////////////////////////////////

