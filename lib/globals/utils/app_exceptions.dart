class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class EmailAlreadyUsedException extends AppException {
  const EmailAlreadyUsedException() : super('Email já cadastrado');
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException() : super('Credenciais inválidas');
}

class UserNotFoundException extends AppException {
  const UserNotFoundException() : super('Usuário não encontrado');
}

class ReferralNotFoundException extends AppException {
  const ReferralNotFoundException() : super('Código de indicação inválido');
}

class InsufficientPointsException extends AppException {
  const InsufficientPointsException() : super('Pontos insuficientes');
}

class WithdrawalBelowMinimumException extends AppException {
  const WithdrawalBelowMinimumException()
      : super('Valor mínimo para saque é R\$ 50,00');
}

class InsufficientBalanceException extends AppException {
  const InsufficientBalanceException()
      : super('Saldo insuficiente para saque');
}
