import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  int? count,
  String confirmText = 'Evet, Devam Et',
  String cancelText = 'Vazgeç',
  IconData icon = Icons.check_circle_rounded,
}) {
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
        backgroundColor: theme.colorScheme.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              if (count != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.done_all_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "$count Kaynak Seçildi",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                content,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
