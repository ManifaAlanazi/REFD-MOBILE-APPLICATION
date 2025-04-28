import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';
import 'package:refd_app/widgets/common_asset_image_widget.dart';
import 'package:refd_app/widgets/common_loader_widget.dart';


class CommonCachedImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double loaderSize;

  const CommonCachedImageWidget({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.loaderSize,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imagePath,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CommonLoaderWidget(
        color: AppColors.mainColor,
      ),
      errorWidget: (context, url, error) => CommonAssetImage(
        width: width,
        height: height,
        imageName: "no_image_found.png",
        boxFit: BoxFit.cover,
      ),
    );
  }
}
