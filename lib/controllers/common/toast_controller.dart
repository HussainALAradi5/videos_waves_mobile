import 'package:flutter/foundation.dart';

import '../../constants/common/toast_constants.dart';
import '../../enums/common/toast_type.dart';
import '../../models/common/ui/toast_item.dart';

/// The app-wide toast queue, shown by the toast overlay above every screen.
class ToastController extends ChangeNotifier {
  final List<ToastItem> _items = [];
  int _nextId = 1;

  List<ToastItem> get visible => List.unmodifiable(_items.take(ToastLooks.maxVisible));

  int show(ToastType type, String message, {String? description, Duration? duration, String? actionLabel, VoidCallback? onAction, bool isPausable = true}) {
    final item = ToastItem(
      id: _nextId++,
      type: type,
      message: message,
      description: description,
      duration: duration ?? ToastLooks.defaultDuration,
      actionLabel: actionLabel,
      onAction: onAction,
      isPausable: isPausable,
    );
    _items.add(item);
    if (_items.length > ToastLooks.maxQueued) _items.removeAt(0);
    notifyListeners();
    return item.id;
  }

  void dismiss(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
