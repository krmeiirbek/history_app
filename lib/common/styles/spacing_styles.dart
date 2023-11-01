import 'package:flutter/cupertino.dart';
import 'package:history_app/utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: TSizes.appBarHeight,
    left: TSizes.spaceBtwItems,
    right: TSizes.spaceBtwItems,
    bottom: TSizes.spaceBtwItems,
  );
}
