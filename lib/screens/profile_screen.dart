import 'dart:io';
import 'dart:math';

import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/widgets/focusable_profile_image.dart';
import 'package:chat_app/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  File? _pickedImage;
  final ImagePicker picker = ImagePicker();
  void _pickImage(imageSource, context) async {
    final pickedImageFile = await picker.pickImage(
        source: imageSource, imageQuality: 50, maxHeight: 300, maxWidth: 300);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      Provider.of<UserProvider>(context, listen: false)
          .changeProfilePicture(_pickedImage);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios),
            ),
            const SizedBox(width: 10),
            const Text('Profile',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                FocusableProfileImage(
                    Provider.of<UserProvider>(context).profileImage!,
                    radius: 70),
                InkWell(
                  onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (ctx) => SizedBox(
                            height: 150,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _pickImage(ImageSource.camera, context),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          'Camera',
                                          style: TextStyle(fontSize: 22),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _pickImage(
                                        ImageSource.gallery, context),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.picture_in_picture_outlined,
                                          size: 40,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          'Gallery',
                                          style: TextStyle(fontSize: 22),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    child: const Icon(Icons.photo_camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name', style: TextStyle(fontSize: 16)),
                      Text(Provider.of<UserProvider>(context).username!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        _usernameController.text =
                            Provider.of<UserProvider>(context, listen: false)
                                .username!;
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (ctx) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                      top: 20.0,
                                      left: 20.0,
                                      right: 20.0),
                                  child: SizedBox(
                                    height: 140,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MyTextField(
                                            controller: _usernameController,
                                            label: 'Enter your name'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateUserName(
                                                          _usernameController
                                                              .text);
                                                },
                                                child: const Text('Save')),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            TextButton(
                onPressed: () => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 20.0,
                            left: 20.0,
                            right: 20.0),
                        child: SizedBox(
                          height: 240,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTextField(
                                  controller: _oldpasswordController,
                                  label: 'Enter old password',
                                  type: 'pass'),
                              const SizedBox(height: 15),
                              MyTextField(
                                  controller: _newpasswordController,
                                  label: 'Enter new password',
                                  type: 'pass'),
                              const SizedBox(height: 15),
                              MyTextField(
                                  controller: _repasswordController,
                                  label: 'Re-enter new password',
                                  type: 'pass'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .changePassword(
                                                _oldpasswordController.text,
                                                _newpasswordController.text);
                                      },
                                      child: const Text('Save')),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.rotate(
                        angle: 135 * pi / 180,
                        child: const Icon(
                          Icons.key,
                          size: 20,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('Change your password'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
