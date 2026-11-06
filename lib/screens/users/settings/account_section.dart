import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/settings/settings_messages_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../controllers/users/settings/account_controller.dart';
import '../../../enums/common/button_tone.dart';
import '../../../globals/app_dependencies.dart';
import '../../../utilities/media/file_pick_utility.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../validations/users/auth/auth_validation.dart';
import '../../../widgets/common/avatars/user_avatar.dart';
import '../../../widgets/common/buttons/app_button.dart';
import '../../../widgets/common/feedback/app_progress_bar.dart';

/// Profile picture (upload or back to the standard one) and bio.
class AccountSection extends StatefulWidget {
  const AccountSection({super.key});

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  late final AccountController _account = () {
    final dependencies = context.read<AppDependencies>();
    return AccountController(dependencies.settingsService, dependencies.mediaUploadService, dependencies.authController);
  }();
  late final TextEditingController _bio = TextEditingController(text: context.read<AuthController>().user?.bio);
  late final TextEditingController _phone = TextEditingController(text: context.read<AuthController>().user?.phone);
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _account.dispose();
    _bio.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final files = await pickFiles(FileType.image);
    if (files.isEmpty || !mounted) return;
    await runWithFeedback(context, () => _account.changeAvatar(files.first), successMessage: SettingsMessages.photoSaved);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthController>().user;
    if (user == null) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: _account,
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: Spacing.sm),
        Row(children: [
          UserAvatar(user: user.asPublic, size: 64, hasRing: true),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.userName, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(user.email, style: Theme.of(context).textTheme.bodySmall),
              TextButton(onPressed: _account.isSaving ? null : _changePhoto, child: const Text(SettingsMessages.changePhoto)),
              if (user.avatarUrl != null)
                TextButton(
                  onPressed: _account.isSaving ? null : () => runWithFeedback(context, _account.removeAvatar),
                  child: const Text(SettingsMessages.removePhoto),
                ),
            ]),
          ),
        ]),
        if (_account.isSaving && _account.avatarProgress > 0) AppProgressBar(value: _account.avatarProgress),
        const SizedBox(height: Spacing.sm),
        Form(
          key: _form,
          child: Column(children: [
            TextField(controller: _bio, maxLength: 150, maxLines: 3, minLines: 1, decoration: const InputDecoration(labelText: SettingsMessages.bioLabel)),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: validatePhone,
              decoration: const InputDecoration(labelText: SettingsMessages.phoneLabel, helperText: SettingsMessages.phoneHelp),
            ),
          ]),
        ),
        const SizedBox(height: Spacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: AppButton(
            label: SettingsMessages.saveBio,
            tone: ButtonTone.secondary,
            onPressed: () async {
              if (!_form.currentState!.validate()) return;
              await runWithFeedback(context, () => _account.updateDetails(bio: _bio.text, phone: _phone.text), successMessage: SettingsMessages.bioSaved);
            },
          ),
        ),
      ]),
    );
  }
}
