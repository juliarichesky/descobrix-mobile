import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => _gradientButton(),
      AppButtonVariant.secondary => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueLight,
          foregroundColor: AppColors.blueDeep,
        ),
        child: _content,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: onPressed,
        child: _content,
      ),
    };

    return SizedBox(width: expand ? double.infinity : null, child: button);
  }

  Widget get _content => icon == null
      ? Text(label)
      : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon!, const SizedBox(width: 8), Text(label)],
        );

  Widget _gradientButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.primaryButtonGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26F45B95),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.surface,
          shadowColor: Colors.transparent,
        ),
        child: _content,
      ),
    );
  }
}
