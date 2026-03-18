import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const CustomSearchBar({super.key, required this.onSearch});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: TextField(
        controller: _controller,
        style: const TextStyle(
          fontFamily: 'Iceland',
          color: AppTheme.textPrimary,
          fontSize: 18,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          hintText: '> SEARCH QUERY_',
          hintStyle: const TextStyle(
            fontFamily: 'Iceland',
            color: AppTheme.textSecondary,
            fontSize: 16,
            letterSpacing: 1,
          ),
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor, size: 26),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textSecondary, size: 18),
            onPressed: () {
              _controller.clear();
              widget.onSearch('');
            },
          ),
        ),
        onChanged: widget.onSearch,
        onSubmitted: widget.onSearch,
      ),
    );
  }
}
