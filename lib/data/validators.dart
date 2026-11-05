/// Aturan validasi form. Sama dengan validasi di backend (zod).
class Validators {
  Validators._();

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  static String? email(String? value) {
    final empty = required(value, 'Email');
    if (empty != null) return empty;
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim());
    return ok ? null : 'Format email tidak valid';
  }

  static String? username(String? value) {
    final empty = required(value, 'Username');
    if (empty != null) return empty;
    final v = value!.trim();
    if (v.length < 3) return 'Username minimal 3 karakter';
    if (v.length > 30) return 'Username maksimal 30 karakter';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
      return 'Username hanya boleh huruf, angka, dan underscore';
    }
    return null;
  }

  static String? password(String? value) {
    final empty = required(value, 'Password');
    if (empty != null) return empty;
    if (value!.length < 8) return 'Password minimal 8 karakter';
    if (value.length > 72) return 'Password maksimal 72 karakter';
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) return 'Password harus mengandung huruf';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Password harus mengandung angka';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final empty = required(value, 'Konfirmasi password');
    if (empty != null) return empty;
    return value == original ? null : 'Konfirmasi password tidak sama';
  }

  static String? optionalMax(String? value, int max, String label) {
    if (value != null && value.trim().length > max) {
      return '$label maksimal $max karakter';
    }
    return null;
  }

  static String? optionalPhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    return RegExp(r'^\+?[0-9]{8,15}$').hasMatch(v)
        ? null
        : 'Nomor telepon harus 8-15 digit (boleh diawali +)';
  }
}
