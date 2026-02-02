class Validators {
  static String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Informe um email';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(text)) {
      return 'Email inválido';
    }
    return null;
  }

  static String? minLength(String? value, int minLength) {
    final text = value ?? '';
    if (text.length < minLength) {
      return 'Mínimo de $minLength caracteres';
    }
    return null;
  }

  const Validators();
}
