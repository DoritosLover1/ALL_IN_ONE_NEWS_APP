import 'package:flutter/material.dart';

class SelectableItem {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final String? logoPath;

  const SelectableItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    this.logoPath,
  });
}
