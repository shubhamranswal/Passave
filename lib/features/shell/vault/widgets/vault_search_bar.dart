import 'package:flutter/material.dart';

class VaultSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint;

  const VaultSearchBar({
    super.key,
    required this.onChanged,
    this.hint = 'Search vault',
  });

  @override
  State<VaultSearchBar> createState() => _VaultSearchBarState();
}

class _VaultSearchBarState extends State<VaultSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
