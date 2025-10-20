// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double elevation;
  final bool isCentered;
  List<Widget>? actions;
  Widget? leading;
  Widget? title;

  CustomAppBar({
    super.key,
    required this.title,
    this.elevation = 0.0,
    this.isCentered = false,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: isCentered,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
