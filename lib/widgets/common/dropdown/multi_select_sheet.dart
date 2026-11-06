import 'package:flutter/material.dart';

import '../../../constants/common/spacing_constants.dart';
import '../../../models/common/ui/dropdown_option.dart';

/// A searchable multi-select in a bottom sheet with chips for the choices so far.
class MultiSelectSheet<T> extends StatefulWidget {
  const MultiSelectSheet({super.key, required this.title, required this.search, required this.confirmLabel, this.initial = const [], this.hint});

  final String title;
  final String confirmLabel;

  /// Server search for options matching the text.
  final Future<List<DropdownOption<T>>> Function(String text) search;
  final List<DropdownOption<T>> initial;
  final String? hint;

  static Future<List<DropdownOption<T>>?> show<T>(BuildContext context, MultiSelectSheet<T> sheet) =>
      showModalBottomSheet<List<DropdownOption<T>>>(context: context, isScrollControlled: true, showDragHandle: true, builder: (_) => sheet);

  @override
  State<MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<MultiSelectSheet<T>> {
  late final List<DropdownOption<T>> _selected = [...widget.initial];
  List<DropdownOption<T>> _results = [];

  @override
  void initState() {
    super.initState();
    _query('');
  }

  Future<void> _query(String text) async {
    final results = await widget.search(text);
    if (mounted) setState(() => _results = results);
  }

  void _toggle(DropdownOption<T> option) => setState(() {
        final index = _selected.indexWhere((item) => item.value == option.value);
        index < 0 ? _selected.add(option) : _selected.removeAt(index);
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: Spacing.md, right: Spacing.md, bottom: MediaQuery.viewInsetsOf(context).bottom + Spacing.md),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Spacing.sm),
          TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: widget.hint), onChanged: _query),
          const SizedBox(height: Spacing.sm),
          Wrap(spacing: Spacing.sm, children: [
            for (final option in _selected) InputChip(label: Text(option.label), avatar: option.leading, onDeleted: () => _toggle(option)),
          ]),
          Expanded(
            child: ListView(children: [
              for (final option in _results)
                CheckboxListTile(
                  value: _selected.any((item) => item.value == option.value),
                  onChanged: (_) => _toggle(option),
                  secondary: option.leading,
                  title: Text(option.label),
                ),
            ]),
          ),
          FilledButton(onPressed: () => Navigator.of(context).pop(_selected), child: Text(widget.confirmLabel)),
        ]),
      ),
    );
  }
}
