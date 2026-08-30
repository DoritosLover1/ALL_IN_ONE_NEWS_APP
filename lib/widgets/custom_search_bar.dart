import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Kaynak ara',
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: Colors.grey.shade500,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  controller.clear();
                  onClear();
                },
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
