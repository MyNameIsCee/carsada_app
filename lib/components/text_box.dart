import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Text_Box extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isPassword;
  final String? Function(String? value)? validator;
  final AutovalidateMode? autovalidateMode;

  const Text_Box({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.isPassword = false,
    this.validator,
    this.autovalidateMode,
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
    return _buildTextField();
  }

  Widget _buildContainer({required Widget child, required bool hasError}) {
    return Container(
      width: 390,
      decoration: _buildDecoration(hasError: hasError),
      child: child,
    );
  }

  BoxDecoration _buildDecoration({required bool hasError}) {
    return BoxDecoration(
      color: const Color(0xFFFEFEFE),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: hasError ? Colors.red : const Color(0xFF353232),
        width: 1,
      ),
    );
  }

  Widget _buildTextField() {
    return FormField<String>(
      initialValue: widget.controller?.text,
      autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (state) {
        final bool hasError = state.hasError;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContainer(
              hasError: hasError,
              child: TextField(
                controller: widget.controller,
                obscureText: _obscureText,
                keyboardType: widget.isPassword
                    ? TextInputType.visiblePassword
                    : widget.keyboardType,
                onChanged: (value) {
                  state.didChange(value);
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                style: _getTextStyle(),
                decoration: _buildInputDecoration().copyWith(
                  suffixIcon: widget.isPassword ? _buildEyeIcon() : null,
                  hintText: widget.hintText,
                ),
              ),
            ),
            SizedBox(height: 4),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget? _buildEyeIcon() {
    return IconButton(
      icon: HugeIcon(
        icon: _obscureText ? HugeIcons.strokeRoundedViewOff : HugeIcons.strokeRoundedView,
        color: const Color(0xFF353232),
        size: 26,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  TextStyle _getTextStyle() => const TextStyle(
        fontSize: 16,
        color: Colors.black,
      );

  InputDecoration _buildInputDecoration() {
    return const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: InputBorder.none,
      hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
    );
  }
}