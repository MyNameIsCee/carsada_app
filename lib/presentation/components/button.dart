import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 390,
      height: height ?? 50,
      child: isOutlined ? _buildOutlinedButton() : _buildFilledButton(),
    );
  }

  Widget _buildFilledButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: _getFilledButtonStyle(),
      child: _getButtonText(),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: _getOutlinedButtonStyle(),
      child: _getButtonText(),
    );
  }

  ButtonStyle _getFilledButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? const Color(0xFFFFCC00),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      side: BorderSide(
        color: backgroundColor ?? const Color(0xFFFFCC00),
        width: 1,
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
    );
  }

  Widget _getButtonText() {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isOutlined ? (textColor ?? const Color(0xFFFFCC00)) : (textColor ?? Colors.white),
      ),
    );
  }
} 