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
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextField();
  }

  Widget _buildContainer({required Widget child, required bool hasError}) {
    return Container(
      width: 390,
      height: 65,  
      decoration: _buildDecoration(hasError: hasError),
      child: child,
    );
  }

  BoxDecoration _buildDecoration({required bool hasError}) {
    Color borderColor;
    if (hasError) {
      borderColor = Colors.red;
    } else if (_isFocused) {
      borderColor = const Color.fromARGB(255, 27, 27, 27); 
    } else {
      borderColor = Colors.grey; 
    }

    return BoxDecoration(
      color: const Color(0xFFFEFEFE),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: borderColor,
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
        final bool hasText = widget.controller?.text.isNotEmpty ?? false;
        final bool shouldShowLabel = _isFocused || hasText;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildContainer(
                  hasError: hasError,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
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
                      hintText: null, 
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 25, // to find the center change here
                      ),
                    ),
                  ),
                ),
                if (widget.hintText != null)
                  Positioned(
                    left: 20,
                    top: shouldShowLabel ? 8 : 25, // it is for the heading label
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: shouldShowLabel ? 12 : 14,
                        color: shouldShowLabel 
                            ? const Color(0xFF36454F) 
                            : const Color(0xFF999999), 
                        fontWeight: shouldShowLabel ? FontWeight.w500 : FontWeight.normal,
                      ),
                      child: Text(widget.hintText!),
                    ),
                  ),
              ],
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
    );
  }
}