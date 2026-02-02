class RegisterInput {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String? referralCode;

  const RegisterInput({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.referralCode,
  });
}

class LoginInput {
  final String email;
  final String password;

  const LoginInput({
    required this.email,
    required this.password,
  });
}

class ProfileUpdateInput {
  final String userId;
  final String fullName;
  final String phone;

  const ProfileUpdateInput({
    required this.userId,
    required this.fullName,
    required this.phone,
  });
}
