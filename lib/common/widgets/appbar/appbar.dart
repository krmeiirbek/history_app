import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.leadingIcon,
    this.title,
    this.actions,
    this.leadingIconOnPressed,
    this.showBackArrowIcon = true,
  });

  final bool showBackArrowIcon;
  final IconData? leadingIcon;
  final Widget? title;
  final List<Widget>? actions;
  final VoidCallback? leadingIconOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      child: AppBar(
        // Custom back arrow
        automaticallyImplyLeading: false,
        leading: showBackArrowIcon
            ? IconButton(
                onPressed: leadingIconOnPressed ?? (showBackArrowIcon ? () => Get.back() : null),
                icon: Icon(
                  leadingIcon ?? (showBackArrowIcon ? Iconsax.arrow_left : null),
                  color: THelperFunctions.isDarkMode(context) ? kDefaultIconLightColor : kDefaultIconDarkColor,
                ),
              )
            : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
