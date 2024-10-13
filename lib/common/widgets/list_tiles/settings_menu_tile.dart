import 'package:dev_mind/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TSettingsMenuTile extends StatelessWidget {
  const TSettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap
  });

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TColors.accent, width: 1.5),
        borderRadius: BorderRadius.circular(8)
      ),
      child: ListTile(
        leading: Icon(icon, size: 28, color: TColors.accent),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
        trailing: trailing,
        onTap: onTap,
      )
    );
  }
}
