import 'package:flutter/material.dart';

class CircleImg extends StatelessWidget {
  final double imageRadius;
  final ImageProvider imageProvider;

  const CircleImg(
      {Key? key, this.imageRadius = 20, required this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: imageRadius,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        backgroundImage: imageProvider,
        radius: imageRadius - 5,
      ),
    );
  }
}
