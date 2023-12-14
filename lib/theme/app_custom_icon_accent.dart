import 'package:flutter/material.dart';

import 'app_colors.dart';

class CustomIconAccent extends StatelessWidget {
  final IconData icon;

  const CustomIconAccent({Key? key, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: AppColors.accent,
    );
  }
}
