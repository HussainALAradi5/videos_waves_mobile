import 'package:flutter/material.dart';

import '../../../constants/users/admin_users/admin_users_constants.dart';
import '../../../enums/common/button_tone.dart';
import '../../common/buttons/app_button.dart';
import '../../common/dialogs/confirm_dialog.dart';

/// Activate straight away, or deactivate after a confirmation; the caller hides it for admins.
class AccountStatusButton extends StatelessWidget {
  const AccountStatusButton({super.key, required this.userName, required this.isActive, required this.onChanged});

  final String userName;
  final bool isActive;
  final Future<void> Function(bool isActive) onChanged;

  Future<void> _deactivate(BuildContext context) async {
    final isConfirmed = await ConfirmDialog.show(
      context,
      title: AdminUsersMessages.confirmTitle(userName),
      message: AdminUsersMessages.confirmBody,
      confirmLabel: AdminUsersMessages.deactivate,
    );
    if (isConfirmed) await onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return isActive
        ? AppButton(label: AdminUsersMessages.deactivate, tone: ButtonTone.danger, onPressed: () => _deactivate(context))
        : AppButton(label: AdminUsersMessages.activate, tone: ButtonTone.secondary, onPressed: () => onChanged(true));
  }
}
