import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key, required this.imgUrl, required this.width, required this.height});

  final String imgUrl;
  final double width;
  final double height;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.width),
      child: Image.network(
        widget.imgUrl,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}