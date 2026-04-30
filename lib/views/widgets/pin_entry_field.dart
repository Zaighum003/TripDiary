// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class PinEntryField extends StatefulWidget {
  final Function(String) onPinChanged;
  final Function()? onSubmit;
  final int pinLength;
  final TextEditingController? controller;

  const PinEntryField({
    Key? key,
    required this.onPinChanged,
    this.onSubmit,
    this.pinLength = 4,
    this.controller,
  }) : super(key: key);

  @override
  State<PinEntryField> createState() => _PinEntryFieldState();
}

class _PinEntryFieldState extends State<PinEntryField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(PinEntryField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: widget.pinLength,
          onChanged: (value) {
            widget.onPinChanged(value);
            if (value.length == widget.pinLength && widget.onSubmit != null) {
              widget.onSubmit!();
            }
          },
          decoration: InputDecoration(
            hintText: AppStrings.pinPlaceholder,
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
          ),
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                letterSpacing: 16,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            widget.pinLength,
            (index) {
              final hasValue = _controller.text.length > index;
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasValue ? AppColors.primary : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: hasValue
                    ? Icon(
                        Icons.check,
                        color: AppColors.primary,
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
