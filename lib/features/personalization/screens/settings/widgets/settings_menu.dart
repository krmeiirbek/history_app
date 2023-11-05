import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';


class TSettingsMenu extends StatelessWidget {
  const TSettingsMenu({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.onPressed,
    this.trailing,
  });

  final IconData icon;
  final String title, subTitle;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(icon, size: 28, color: TColors.primary),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
        trailing: trailing,
      ),
    );
  }
}