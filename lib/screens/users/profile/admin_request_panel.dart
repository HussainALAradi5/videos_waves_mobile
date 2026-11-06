import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/limits_constants.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/admin_request/admin_request_status_constants.dart';
import '../../../controllers/users/admin_request/my_admin_request_controller.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../validations/users/admin_request/admin_request_validation.dart';
import '../../../widgets/common/badges/status_chip.dart';
import '../../../widgets/common/feedback/error_view.dart';
import '../../../widgets/common/feedback/loading_view.dart';
import '../../../widgets/common/forms/app_text_field.dart';
import '../../../widgets/common/forms/submit_button.dart';

/// Request admin access, see the latest request's status, or cancel a pending one.
class AdminRequestPanel extends StatefulWidget {
  const AdminRequestPanel({super.key});

  @override
  State<AdminRequestPanel> createState() => _AdminRequestPanelState();
}

class _AdminRequestPanelState extends State<AdminRequestPanel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _create(MyAdminRequestController controller) async {
    if (!_formKey.currentState!.validate()) return;
    if (await runWithFeedback(context, () => controller.create(_reason.text))) _reason.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyAdminRequestController>();
    final latest = controller.latest;
    final theme = Theme.of(context);
    if (controller.isLoading) return const LoadingView();
    if (controller.error != null) return ErrorView(error: controller.error!, onRetry: controller.load);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppMessages.adminRequestTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: Spacing.xs),
        Text(AppMessages.adminRequestHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: Spacing.md),
        if (latest != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(AppMessages.adminRequestLatest),
            subtitle: Text(latest.reason),
            trailing: StatusChip(option: adminRequestStatusOptions[latest.status]!),
          ),
        if (controller.canRequest)
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _reason,
                  label: AppMessages.adminRequestReason,
                  maxLines: 3,
                  maxLength: TextLimits.adminReasonMax,
                  validator: validateAdminReason,
                ),
                SubmitButton(
                  label: AppMessages.adminRequestSubmit,
                  isLoading: controller.isSubmitting,
                  onPressed: () => _create(controller),
                ),
              ],
            ),
          )
        else
          OutlinedButton(
            onPressed: controller.isSubmitting ? null : () => runWithFeedback(context, controller.cancel),
            child: const Text(AppMessages.adminRequestCancel),
          ),
      ],
    );
  }
}
