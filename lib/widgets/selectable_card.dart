import 'package:flutter/material.dart';
import 'package:flutter_medic/models/selectable_item.dart';

class SelectableCard extends StatelessWidget {
  final SelectableItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade200,
              width: isSelected ? 2.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? primaryColor.withOpacity(0.08)
                    : Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.badgeColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  item.badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primaryColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
