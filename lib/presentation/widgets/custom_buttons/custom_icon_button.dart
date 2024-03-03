import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kursova/core/utils/image_asset_path_formater.dart';

class CustomIconButton extends StatelessWidget {
  final void Function()? onTap;
  final String iconPath;
  final double iconSize;
  final Color? iconColor;

  const CustomIconButton({
    super.key,
    this.onTap,
    required this.iconPath,
    this.iconSize = 14,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: SvgPicture.asset(
          ImageAssetPathFormater.formatImageAssetPath(
            imageAssetPath: iconPath,
          ),
          colorFilter: iconColor == null
              ? null
              : ColorFilter.mode(
                  iconColor!,
                  BlendMode.srcIn,
                ),
        ),
      ),
    );
  }
}
