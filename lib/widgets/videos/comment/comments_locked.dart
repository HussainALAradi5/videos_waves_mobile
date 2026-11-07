import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../enums/common/button_tone.dart';
import '../../common/buttons/app_button.dart';

/// What guests see instead of the comments (same as the web): a lock, why, and the way in.
class CommentsLocked extends StatelessWidget {
  const CommentsLocked({super.key, required this.returnTo});

  /// Where to come back after signing in (this video).
  final String returnTo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 20, backgroundColor: scheme.primary.withValues(alpha: 0.15), child: Icon(Icons.lock_outline, color: scheme.primary)),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(AppMessages.commentsLockedTitle, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(AppMessages.commentsLockedDescription, style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ]),
        const SizedBox(height: Spacing.md),
        Row(children: [
          AppButton(
            label: AppMessages.loginSubmit,
            tone: ButtonTone.gradient,
            onPressed: () async => context.push('${AppRoutes.login}?${AppRoutes.redirectParam}=${Uri.encodeComponent(returnTo)}'),
          ),
          const SizedBox(width: Spacing.sm),
          AppButton(label: AppMessages.signUp, tone: ButtonTone.secondary, onPressed: () async => context.push(AppRoutes.register)),
        ]),
      ]),
    );
  }
}
