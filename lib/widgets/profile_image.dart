import 'package:flutter/material.dart';
import '../utilities/instagram_service.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.userName, required this.width, required this.height});

  final String userName;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(this.width),
      child: FutureBuilder(
        future: InstagramService().getUserProfileImgUrl(this.userName),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Image.network(
              snapshot.data.toString(),
              width: this.width,
              height: this.height,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Image(
                  image: AssetImage('assets/img_profile_default.jpg'),
                  width: this.width,
                  height: this.height,
                );
              },
            );
          }
          else {
            return Image(
              image: AssetImage('assets/img_profile_default.jpg'),
              width: this.width,
              height: this.height,
            );
          }
        },
      ),
    );
  }
}