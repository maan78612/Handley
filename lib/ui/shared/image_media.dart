import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Auth/Widget/view_profile_picture.dart';

class UserImageOptionSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _mediaOption(0, "Camera", Icons.camera_alt),
            _mediaOption(1, "Gallery", Icons.image),
            _mediaOption(2, "View", Icons.person),
          ],
        ),
      ),
    );
  }

  Future<File?> pickImage(ImageSource src) async {
    XFile? pickedFile = await _picker.pickImage(source: src, imageQuality: 70);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  _mediaOption(int index, String title, IconData icon) {
    return ListTile(
      onTap: () async {
        switch (index) {
          case 0:
            {
              File? f = await pickImage(
                ImageSource.camera,
              );
              Get.back(result: f);
            }
            break;
          case 1:
            {
              File? f = await pickImage(
                ImageSource.gallery,
              );
              Get.back(result: f);
            }
            break;

          case 2:
            {
              Get.back();
              Navigator.of(Get.context!).push(MaterialPageRoute(
                builder: (_) => const ProfilePreview(),
              ));
            }
            break;
        }
      },
      title: Text(title),
      leading: Icon(icon),
    );
  }
}

class DocumentFileOptionSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _mediaOption(0, "Image", Icons.image),
            _mediaOption(1, "PDF file", Icons.file_copy),
          ],
        ),
      ),
    );
  }

  Future<File?> pickImage(ImageSource src) async {
    XFile? pickedFile = await _picker.pickImage(source: src, imageQuality: 70);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  _mediaOption(int index, String title, IconData icon) {
    return ListTile(
      onTap: () async {
        switch (index) {
          case 0:
            {
              File? f = await pickImage(
                ImageSource.gallery,
              );
              Get.back(result: f);
            }
            break;
          case 1:
            {
              File? f = await _fileFromPhone();
              Get.back(result: f);
            }
            break;
        }
      },
      title: Text(title),
      leading: Icon(icon),
    );
  }

  Future<File?> _fileFromPhone() async {
    PlatformFile? pickedFile;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pickedFile = result.files.first;
      final file = File(pickedFile.path!);
      return file;
    } else {
      return null;
    }
  }
}
