import 'package:flutter/material.dart';

class Back_Icon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const Back_Icon({
    Key? key,
    this.onPressed,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios,
        color: const Color.fromARGB(255, 40, 39, 39),
        size: size ?? 26,
      ),
    );
  }
} 