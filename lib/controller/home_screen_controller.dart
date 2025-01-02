import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreenController with ChangeNotifier {
  String url = "";
  // collection reference
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  void addItem({required String title, required String description}) async {
    print({"name": title, "des": description, "url": url});
    itemsCollection.add({"name": title, "des": description, "url": url});
  }

  updateItem({required String id, String? title, String? description}) async {
    itemsCollection
        .doc(id)
        .update({"name": title, "des": description, "url": url});
  }

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();

    // Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
// Points to the root reference
      final storageRef = FirebaseStorage.instance.ref();

      // Points to "images" folder
      Reference? folderRef = storageRef.child("images");

      final imageRef = folderRef.child("$timestamp.jpg");

      await imageRef.putFile(File(photo.path));

      var downloadUrl = await imageRef.getDownloadURL();

      log(downloadUrl.toString());
      url = downloadUrl.toString();
    } else {
      print('No image selected.');
    }
  }
}
