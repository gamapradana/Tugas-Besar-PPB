/// Data profil tambahan (tabel user_profiles).
class ProfileModel {
  const ProfileModel({
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
  });

  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        phoneNumber: json['phoneNumber'] as String?,
        address: json['address'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        country: json['country'] as String?,
        zipcode: json['zipcode'] as String?,
      );
}

/// Data akun pengguna (tabel users + user_profiles).
class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullname,
    this.isEmailVerified = false,
    this.profilePicture,
    this.isActive = true,
    this.profile,
  });

  final int id;
  final String? fullname;
  final String username;
  final String email;
  final bool isEmailVerified;
  final String? profilePicture;
  final bool isActive;
  final ProfileModel? profile;

  /// Nama untuk ditampilkan: nama lengkap, atau username jika kosong.
  String get displayName {
    final name = fullname?.trim();
    return (name != null && name.isNotEmpty) ? name : username;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        fullname: json['fullname'] as String?,
        username: json['username'] as String,
        email: json['email'] as String,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        profilePicture: json['profilePicture'] as String?,
        isActive: json['isActive'] as bool? ?? true,
        profile: json['profile'] is Map<String, dynamic>
            ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
            : null,
      );
}
