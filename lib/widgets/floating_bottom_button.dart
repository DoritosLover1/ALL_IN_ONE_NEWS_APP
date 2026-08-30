import 'package:flutter/material.dart';

class FloatingBottomButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const FloatingBottomButton({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Material(
          color: Colors.transparent,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
