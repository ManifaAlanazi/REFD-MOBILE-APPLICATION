import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAssetSvgImageWidget extends StatelessWidget {
  final String name;
  final double width;
  final double height;
  final BoxFit? imageBoxFit;
  final Color? color;

  const CommonAssetSvgImageWidget({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    this.imageBoxFit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return color == null
        ? SvgPicture.asset(
            "assets/images/$name",
            height: height,
            width: width,
            fit: imageBoxFit ?? BoxFit.fill,
          )
        : SvgPicture.asset(
            "assets/images/$name",
            height: height,
            width: width,
            fit: imageBoxFit ?? BoxFit.contain,
            colorFilter: ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
          );
  }
}
