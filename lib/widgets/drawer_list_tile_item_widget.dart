import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';

class CommonDrawerListTileItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showIcon;

  const CommonDrawerListTileItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.color = AppColors.darkColor,
    this.iconColor = AppColors.mainColor,
    this.showIcon = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
      trailing: showIcon
          ? const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 12,
              color: AppColors.greyColor,
            )
          : const SizedBox(),
      title: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
