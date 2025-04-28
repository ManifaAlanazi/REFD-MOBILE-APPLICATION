import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validate;
  final String? labelTitle;
  final bool isPassword;
  final int maxLines;
  final int minLines;
  final double radius;
  final bool showPrefixIcon;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? onChange;
  final bool autoFocus;

  const CommonTextFormField({
    super.key,
    required this.controller,
    required this.validate,
    required this.labelTitle,
    this.isPassword = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.radius = 10.0,
    this.showPrefixIcon = true,
    required this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.onChange,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      onTap: onTap,
      onChanged: onChange,
      readOnly: readOnly,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      obscureText: isPassword,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.darkColor,
      ),
      controller: controller,
      validator: validate,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.greyColor.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.mainColor.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.logoRedColor.withOpacity(0.2),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.logoRedColor.withOpacity(0.2),
          ),
        ),
        filled: true,
        fillColor: AppColors.textFormFieldBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelText: labelTitle,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.greyColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
