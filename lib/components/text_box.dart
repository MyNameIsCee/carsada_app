import 'package:flutter/material.dart';

class Text_Box extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isPassword;


  const Text_Box({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.isPassword = false,
 
  });

  @override
  State<Text_Box> createState() => _TextBoxState();
}

class _TextBoxState extends State<Text_Box> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContainer(child: _buildTextField(),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: 390,
      height: 65,
      decoration: _buildDecoration(),
      child: child,
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFEFEFE),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: const Color(0xFF353232),
        width: 1,
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.isPassword ? TextInputType.visiblePassword : widget.keyboardType,
      onChanged: widget.onChanged,
      style: _getTextStyle(),
      decoration: _buildInputDecoration()
    );
  }

  TextStyle _getTextStyle() => const TextStyle(
        fontSize: 16,
        color: Colors.black,
      );

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: _getHintStyle(),
      border: InputBorder.none,
      contentPadding: _getContentPadding(),
      suffixIcon: widget.isPassword ? _buildEyeIcon() : null,
    );
  }

    Widget? _buildEyeIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 10.0), 
      child: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: const Color.fromARGB(255, 137, 132, 132),
          size: 26,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }

  TextStyle _getHintStyle() => const TextStyle(
        fontSize: 16,
        color: Color(0xFF999999),
      );

  EdgeInsets _getContentPadding() => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      );
}
