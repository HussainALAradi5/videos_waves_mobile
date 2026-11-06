import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../dtos/users/auth/register_request_dto.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../validations/users/auth/auth_validation.dart';
import '../../../widgets/common/forms/app_text_field.dart';
import '../../../widgets/common/forms/submit_button.dart';
import '../../../widgets/users/auth/auth_form_card.dart';

/// Registration signs the user in, then opens the feed.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _userName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthController>();
    final router = GoRouter.of(context);
    final dto = RegisterRequestDto(userName: _userName.text.trim(), email: _email.text.trim(), password: _password.text);
    if (await runWithFeedback(context, () => auth.register(dto))) router.go(AppRoutes.feed);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.select<AuthController, bool>((auth) => auth.isSubmitting);
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: AuthFormCard(
          title: AppMessages.registerTitle,
          fields: [
            AppTextField(
              controller: _userName,
              label: AppMessages.userNameLabel,
              autofillHints: const [AutofillHints.newUsername],
              validator: validateUserName,
            ),
            AppTextField(
              controller: _email,
              label: AppMessages.emailLabel,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: validateEmail,
            ),
            AppTextField(
              controller: _password,
              label: AppMessages.passwordLabel,
              isObscured: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validator: validatePassword,
              onSubmitted: (_) => _submit(),
            ),
            SubmitButton(label: AppMessages.registerSubmit, isLoading: isSubmitting, onPressed: _submit),
          ],
          footer: TextButton(
            onPressed: () => context.pushReplacement(AppRoutes.login),
            child: const Text(AppMessages.goToLogin),
          ),
        ),
      ),
    );
  }
}
