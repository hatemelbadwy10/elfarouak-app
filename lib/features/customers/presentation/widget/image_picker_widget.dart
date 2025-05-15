import 'dart:io';
import 'package:flutter/material.dart';
import 'package:elfarouk_app/core/services/image_picker.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';

class PickSingleImageWidget extends StatelessWidget {
  final File? image;
  final ValueChanged<File> onImagePicked;

  const PickSingleImageWidget({
    required this.image,
    required this.onImagePicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.image, color: Colors.pink, size: 30),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            image != null ? image!.path.split('/').last : 'اختر صورة من المعرض',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.photo_library, color: Colors.grey, size: 20),
          onPressed: () async {
            final pickedImage = await getIt<ImagePickerService>().pickImageFromGallery();
            if (pickedImage != null) {
              onImagePicked(pickedImage);
            }
          },
        ),
      ],
    );
  }
}
