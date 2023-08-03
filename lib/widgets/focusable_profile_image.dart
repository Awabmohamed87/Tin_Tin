import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FocusableProfileImage extends StatefulWidget {
  final String userProfile;
  double radius;
  FocusableProfileImage(this.userProfile, {this.radius = 27, super.key});

  @override
  State<FocusableProfileImage> createState() => _FocusableProfileImageState();
}

class _FocusableProfileImageState extends State<FocusableProfileImage> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (_) => Dialog(
                child: Image.network(widget.userProfile, fit: BoxFit.fill),
              )),
      child: CircleAvatar(
        radius: widget.radius,
        backgroundImage: NetworkImage(widget.userProfile),
      ),
    );
  }
}
