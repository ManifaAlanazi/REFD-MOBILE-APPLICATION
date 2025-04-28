import 'package:flutter/material.dart';

class CommonAssetImage extends StatelessWidget {
  final String imageName;
  final double height;
  final double width;
  final BoxFit boxFit;

  const CommonAssetImage({
    super.key,
    required this.width,
    required this.height,
    required this.imageName,
    this.boxFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/$imageName",
      height: height,
      width: width,
      fit: boxFit,
    );
  }
}
