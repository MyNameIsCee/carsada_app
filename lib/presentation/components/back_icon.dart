import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';


class Back_Icon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const Back_Icon({
    super.key,
    this.onPressed,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowLeft01,
        size: size ?? 35,
        color: color ?? const Color(0xFF353232),
      ),
    );
  }
} 