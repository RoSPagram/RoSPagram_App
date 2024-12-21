import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utilities/avatar_util.dart';

class ProfileAvatar extends StatefulWidget {
  ProfileAvatar({super.key, required this.avatar});

  Avatar avatar;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}
class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    widget.avatar.applyRandom();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            widget.avatar.applyRandom();
          });
        },
        child: SvgPicture.string(
          widget.avatar.getSVG(),
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}