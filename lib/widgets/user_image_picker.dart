import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  // ignore: prefer_typing_uninitialized_variables
  var _pickedImage;
  final ImagePicker picker = ImagePicker();
  void _pickImage(imageSource) async {
    final pickedImageFile = await picker.pickImage(source: imageSource);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.black,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      'Add Image \nfrom Camera',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                )),
            InkWell(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(Icons.picture_in_picture_outlined,
                        color: Theme.of(context).primaryColor),
                    const SizedBox(width: 10),
                    Text(
                      'Add Image \n from Gallery',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ))
          ],
        )
      ],
    );
  }
}
