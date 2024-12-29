import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.url, required this.width, required this.height});

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    Image defaultImg = Image(
      image: AssetImage('assets/img_profile_default.jpg'),
      width: this.width,
      height: this.height,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(this.width),
      child: Image.network(
        this.url,
        width: this.width,
        height: this.height,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) => defaultImg,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return defaultImg;
        },
      ),
    );
  }
}