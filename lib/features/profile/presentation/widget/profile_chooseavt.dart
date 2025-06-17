import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerOptions extends StatelessWidget {
  final Function(ImageSource) onImagePicked;

  const ImagePickerOptions({super.key, required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 150,
      child: Column(
        children: [
          const Text(
            'Chọn ảnh đại diện',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onImagePicked(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Chụp ảnh'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onImagePicked(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Chọn từ thư viện'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
