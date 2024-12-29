import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utilities/avatar_util.dart';

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({super.key, required this.avatarData, required this.width, required this.height});

  String? avatarData;
  double width, height;

  @override
  Widget build(BuildContext context) {
    Avatar avatar = avatarData == null ? new Avatar() : Avatar.fromJSON(jsonDecode(avatarData!));
    return SvgPicture.string(
      avatar.getSVG(),
      width: this.width,
      height: this.height,
    );
  }
}