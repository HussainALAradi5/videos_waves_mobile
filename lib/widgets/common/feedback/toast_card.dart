import 'package:flutter/material.dart';

import '../../../constants/common/toast_constants.dart';
import '../../../globals/app_toasts.dart';
import '../../../models/common/ui/toast_item.dart';

/// One toast: slides down and fades in, a bar empties as time runs out (holding it pauses), swipe or tap x to close.
class ToastCard extends StatefulWidget {
  const ToastCard({super.key, required this.item});

  final ToastItem item;

  @override
  State<ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<ToastCard> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(vsync: this, duration: ToastLooks.enter)..forward();
  late final AnimationController _countdown = AnimationController(vsync: this, duration: widget.item.duration)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) _close();
    })
    ..forward();

  Future<void> _close() async {
    if (!mounted) return;
    await _enter.reverse();
    appToasts.dismiss(widget.item.id);
  }

  @override
  void dispose() {
    _enter.dispose();
    _countdown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final look = ToastLooks.byType[item.type]!;
    final scheme = Theme.of(context).colorScheme;
    final curve = CurvedAnimation(parent: _enter, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn);
    return FadeTransition(
      opacity: _enter,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, -0.6), end: Offset.zero).animate(curve),
        child: Dismissible(
          key: ValueKey(item.id),
          onDismissed: (_) => appToasts.dismiss(item.id),
          child: GestureDetector(
            onTapDown: item.isPausable ? (_) => _countdown.stop() : null,
            onTapUp: item.isPausable ? (_) => _countdown.forward() : null,
            onTapCancel: item.isPausable ? _countdown.forward : null,
            child: Material(
              color: scheme.surfaceContainerHigh,
              elevation: 6,
              shadowColor: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Stack(children: [
                Positioned(left: 0, top: 0, bottom: 0, child: Container(width: 4, color: look.color)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 4, 12),
                  child: Row(children: [
                    CircleAvatar(radius: 16, backgroundColor: look.color.withValues(alpha: 0.16), child: Icon(look.icon, color: look.color, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Text(item.message, style: const TextStyle(fontWeight: FontWeight.w600)),
                        if (item.description != null)
                          Text(item.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                      ]),
                    ),
                    if (item.actionLabel != null)
                      TextButton(
                        onPressed: () {
                          item.onAction?.call();
                          _close();
                        },
                        child: Text(item.actionLabel!),
                      ),
                    IconButton(visualDensity: VisualDensity.compact, icon: const Icon(Icons.close, size: 18, semanticLabel: ToastLooks.dismiss), onPressed: _close),
                  ]),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedBuilder(
                    animation: _countdown,
                    builder: (_, _) => LinearProgressIndicator(
                      value: 1 - _countdown.value,
                      minHeight: 2,
                      color: look.color.withValues(alpha: 0.6),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
