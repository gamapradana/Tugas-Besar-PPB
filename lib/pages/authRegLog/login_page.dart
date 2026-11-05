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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _rememberMe = true;
  bool _loading = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      // Jika berhasil, status berubah dan router otomatis membuka Home.
      await ref.read(authControllerProvider.notifier).login(
            identifier: _identifier.text.trim(),
            password: _password.text,
            rememberMe: _rememberMe,
          );
    } on ApiException catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, e.message, type: AppSnackType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _comingSoon(String feature) =>
      showAppSnackBar(context, '$feature segera hadir', type: AppSnackType.info);

  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;

    return AuthScaffold(
      headline: 'Selamat Datang Kembali di Cyclefy!',
      subtitle: 'Senang melihatmu lagi. Siap melanjutkan kebaikan untuk bumi?',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Masuk ke Cyclefy', style: t.headlineSmall),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: 'Email atau Username',
              hint: 'Masukkan email atau username',
              isRequired: true,
              controller: _identifier,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              validator: (v) => Validators.required(v, 'Email atau username'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Password',
              hint: 'Masukkan password',
              isRequired: true,
              isPassword: true,
              controller: _password,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: (v) => Validators.required(v, 'Password'),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),
                Text('Ingat saya', style: t.bodySmall),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(minimumSize: const Size(48, 40)),
                  onPressed: () => _comingSoon('Reset password'),
                  child: const Text('Lupa password?'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Masuk', isLoading: _loading, onPressed: _submit),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    'atau masuk dengan',
                    style: t.labelSmall?.copyWith(color: AppColors.gray600),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(label: 'G', onTap: () => _comingSoon('Login Google')),
                const SizedBox(width: AppSpacing.md),
                _SocialButton(label: 'f', onTap: () => _comingSoon('Login Facebook')),
                const SizedBox(width: AppSpacing.md),
                _SocialButton(label: 'X', onTap: () => _comingSoon('Login X')),
              ],
            ),
            const Spacer(),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun?', style: t.bodySmall),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Daftar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tombol login sosial (tampilan saja; FR-1.4 belum dikerjakan).
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(72, AppSizes.buttonHeight),
          foregroundColor: AppColors.gray900,
        ),
        onPressed: onTap,
        child: Text(label, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
