import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:refd_app/helpers/colors.dart';

class CommonLoaderWidget extends StatelessWidget {
  final Color color;
  final double size;

  const CommonLoaderWidget({
    super.key,
    this.color = AppColors.mainColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      color: color,
      size: size,
    );
  }
}
