import 'package:flutter/material.dart';
import 'package:refd_app/widgets/common_asset_image_widget.dart';

class CommonLogoWidget extends StatelessWidget {
  final double width;
  final double height;

  const CommonLogoWidget({
    super.key,
    this.width = 300.0,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAssetImage(
      width: width,
      height: height,
      imageName: "logo.png",
      boxFit: BoxFit.fill,
    );
  }
}
