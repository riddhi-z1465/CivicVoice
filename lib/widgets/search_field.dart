import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable clean SearchField with clear button, focus state, and civic styling
class CivicSearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final ValueChanged<String>? onSubmitted;

  const CivicSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search...',
    this.onSubmitted,
  });

  @override
  State<CivicSearchField> createState() => _CivicSearchFieldState();
}

class _CivicSearchFieldState extends State<CivicSearchField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_textListener);
  }

  void _textListener() {
    final hasNow = widget.controller.text.isNotEmpty;
    if (hasNow != _hasText) {
      setState(() {
        _hasText = hasNow;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search, size: 19, color: AppColors.textMuted),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
                tooltip: 'Clear search',
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged?.call('');
                  widget.onClear?.call();
                },
              )
            : null,
      ),
    );
  }
}
