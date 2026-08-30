import 'package:flutter/material.dart';

class SelectionBar extends StatelessWidget {
  final String title;
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onClearAll;

  const SelectionBar({
    super.key,
    this.title = 'Haber kaynakları',
    required this.selectedCount,
    required this.onSelectAll,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "$selectedCount seçili",
            style: TextStyle(
              fontSize: 10.5,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSelectAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Text(
              "Tümünü Seç",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onClearAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Text(
              "Temizle",
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
