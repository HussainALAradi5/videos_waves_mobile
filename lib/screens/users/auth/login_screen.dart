import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../config/routes/route_guard.dart';
import '../../../constants/common/messages_constants.dart';
import '../../../constants/common/routes_constants.dart';
import '../../../controllers/users/auth/auth_controller.dart';
import '../../../dtos/users/auth/login_request_dto.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../validations/users/auth/auth_validation.dart';
import '../../../widgets/common/forms/app_text_field.dart';
import '../../../widgets/common/forms/submit_button.dart';
import '../../../widgets/users/auth/auth_form_card.dart';

/// After a successful sign-in, returns to the `redirect` route (or the feed).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identifier = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthController>();
    final router = GoRouter.of(context);
    final target = safeRedirect(GoRouterState.of(context).uri.queryParameters[AppRoutes.redirectParam]);
    final dto = LoginRequestDto(identifier: _identifier.text.trim(), password: _password.text);
    if (await runWithFeedback(context, () => auth.login(dto))) router.go(target);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.select<AuthController, bool>((auth) => auth.isSubmitting);
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: AuthFormCard(
          title: AppMessages.loginTitle,
          fields: [
            AppTextField(
              controller: _identifier,
              label: AppMessages.identifierLabel,
              autofillHints: const [AutofillHints.username],
              validator: (value) => validateRequired(value, AppMessages.identifierLabel),
            ),
            AppTextField(
              controller: _password,
              label: AppMessages.passwordLabel,
              isObscured: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: (value) => validateRequired(value, AppMessages.passwordLabel),
              onSubmitted: (_) => _submit(),
            ),
            SubmitButton(label: AppMessages.loginSubmit, isLoading: isSubmitting, onPressed: _submit),
          ],
          footer: TextButton(
            onPressed: () => context.pushReplacement(AppRoutes.register),
            child: const Text(AppMessages.goToRegister),
          ),
        ),
      ),
    );
  }
}
