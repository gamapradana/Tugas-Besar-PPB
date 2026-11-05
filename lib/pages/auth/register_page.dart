import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/api_exception.dart';
import '../../data/auth_controller.dart';
import '../../data/validators.dart';
import '../app_theme.dart';
import '../shared/app_button.dart';
import '../shared/app_snackbar.dart';
import '../shared/app_text_field.dart';
import '../shared/auth_scaffold.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullname = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _fullname.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).register(
            fullname: _fullname.text.trim(),
            username: _username.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
            confirmPassword: _confirm.text,
          );
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Registrasi berhasil. Silakan masuk.',
        type: AppSnackType.success,
      );
      context.go('/login');
    } on ApiException catch (e) {
      if (!mounted) return;
      final detail =
          e.fieldErrors.isNotEmpty ? e.fieldErrors.values.first : e.message;
      showAppSnackBar(context, detail, type: AppSnackType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;

    return AuthScaffold(
      headline: 'Bergabung dengan Cyclefy',
      subtitle: 'Reuse More. Waste Less. Buat akunmu dan mulai berbagi.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Buat Akun', style: t.headlineSmall),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Nama Lengkap',
              hint: 'Contoh: Budi Santoso',
              controller: _fullname,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: (v) => Validators.optionalMax(v, 255, 'Nama lengkap'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Username',
              hint: 'Contoh: budi_santoso',
              isRequired: true,
              controller: _username,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newUsername],
              validator: Validators.username,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Email',
              hint: 'Contoh: budi@email.com',
              isRequired: true,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Password',
              hint: 'Minimal 8 karakter, huruf dan angka',
              isRequired: true,
              isPassword: true,
              controller: _password,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: Validators.password,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Konfirmasi Password',
              hint: 'Ulangi password',
              isRequired: true,
              isPassword: true,
              controller: _confirm,
              textInputAction: TextInputAction.done,
              validator: (v) => Validators.confirmPassword(v, _password.text),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Daftar', isLoading: _loading, onPressed: _submit),
            const Spacer(),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?', style: t.bodySmall),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Masuk'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
