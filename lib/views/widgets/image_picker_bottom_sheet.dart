import 'dart:io';

import 'package:chat_app/proivders.dart';
import 'package:chat_app/views/utils/extensions/context_extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBottomSheet extends ConsumerWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageNotifier = ref.read(imageProvider.notifier);
    final uploadStatus = ref.watch(uploadStatusProvider.notifier);

    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.camera),
          title: const Text('Take Photo'),
          onTap: () {
            _pickImage(imageNotifier, ref, uploadStatus, ImageSource.camera);
            context.pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Choose from Gallery'),
          onTap: () {
            _pickImage(imageNotifier, ref, uploadStatus, ImageSource.gallery);
            context.pop();
          },
        ),
      ],
    );
  }

  void _pickImage(
    StateController<String?> imageNotifier,
    WidgetRef ref,
    StateController<bool> uploadStatus,
    ImageSource source,
  ) async {
    try {
      uploadStatus.state = true;
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String? imageUrl = await imageUpload(imageFile);
        if (imageUrl != null) {
          imageNotifier.state = imageUrl;
          debugPrint('Image uploaded successfully. URL: $imageUrl');
        } else {
          debugPrint('Failed to upload image.');
        }
      }
    } finally {
      uploadStatus.state = false;
    }
  }

  Future<String?> imageUpload(File imageFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();
      final imagesRef = storageRef.child('images');
      final chatImagesRef = imagesRef.child(
          'images/categories/${DateTime.now().toUtc().toIso8601String()}.jpg');
      UploadTask uploadTask = chatImagesRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
