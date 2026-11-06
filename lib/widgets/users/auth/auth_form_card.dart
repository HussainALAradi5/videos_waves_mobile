import 'package:flutter/material.dart';

import '../../../constants/common/ui_constants.dart';
import '../../common/layout/constrained_content.dart';

/// Shared frame for the sign-in and register forms.
class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.title, required this.fields, required this.footer});

  final String title;
  final List<Widget> fields;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: ConstrainedContent(
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.waves, size: Spacing.xl * 2),
                const SizedBox(height: Spacing.md),
                Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: Spacing.lg),
                for (final field in fields) Padding(padding: const EdgeInsets.only(bottom: Spacing.md), child: field),
                footer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
