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

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullname;
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _country;
  late final TextEditingController _zipcode;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    final p = user?.profile;
    _fullname = TextEditingController(text: user?.fullname ?? '');
    _username = TextEditingController(text: user?.username ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: p?.phoneNumber ?? '');
    _address = TextEditingController(text: p?.address ?? '');
    _city = TextEditingController(text: p?.city ?? '');
    _state = TextEditingController(text: p?.state ?? '');
    _country = TextEditingController(text: p?.country ?? '');
    _zipcode = TextEditingController(text: p?.zipcode ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _fullname, _username, _email, _phone, _address, _city, _state, _country, _zipcode,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).updateProfile({
        'fullname': _fullname.text.trim(),
        'username': _username.text.trim(),
        'phoneNumber': _phone.text.trim(),
        'address': _address.text.trim(),
        'city': _city.text.trim(),
        'state': _state.text.trim(),
        'country': _country.text.trim(),
        'zipcode': _zipcode.text.trim(),
      });
      if (!mounted) return;
      showAppSnackBar(context, 'Profil berhasil diperbarui',
          type: AppSnackType.success);
      context.pop();
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
    const gap = SizedBox(height: AppSpacing.lg);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pageMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Informasi Akun', style: t.titleLarge),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Nama Lengkap',
                  controller: _fullname,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.optionalMax(v, 255, 'Nama lengkap'),
                ),
                gap,
                AppTextField(
                  label: 'Username',
                  isRequired: true,
                  controller: _username,
                  textInputAction: TextInputAction.next,
                  validator: Validators.username,
                ),
                gap,
                // Email tidak dapat diubah (identitas akun).
                AppTextField(label: 'Email', controller: _email, enabled: false),
                const SizedBox(height: AppSpacing.xl),
                Text('Kontak dan Alamat', style: t.titleLarge),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Nomor Telepon',
                  hint: 'Contoh: 081234567890',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: Validators.optionalPhone,
                ),
                gap,
                AppTextField(
                  label: 'Alamat',
                  hint: 'Nama jalan, nomor, RT/RW',
                  controller: _address,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.optionalMax(v, 255, 'Alamat'),
                ),
                gap,
                AppTextField(
                  label: 'Kota',
                  controller: _city,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.optionalMax(v, 255, 'Kota'),
                ),
                gap,
                AppTextField(
                  label: 'Provinsi',
                  controller: _state,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.optionalMax(v, 255, 'Provinsi'),
                ),
                gap,
                AppTextField(
                  label: 'Negara',
                  controller: _country,
                  textInputAction: TextInputAction.next,
                  validator: (v) => Validators.optionalMax(v, 255, 'Negara'),
                ),
                gap,
                AppTextField(
                  label: 'Kode Pos',
                  controller: _zipcode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (v) => Validators.optionalMax(v, 255, 'Kode pos'),
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Simpan Perubahan',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Batal',
                  variant: AppButtonVariant.secondary,
                  onPressed: _loading ? null : () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
