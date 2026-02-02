import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../../core/domain/entities/wallet_transaction.dart';

class WalletController extends ChangeNotifier {
  final WalletRepository repository;

  double balance = 0;
  List<WalletTransaction> transactions = [];
  String? errorMessage;
  bool isLoading = false;

  WalletController({required this.repository});

  Future<void> load(String userId) async {
    await _handle(() async {
      balance = await repository.fetchBalance(userId);
      transactions = await repository.fetchTransactions(userId);
    });
  }

  Future<void> convert(String userId, int points) async {
    await _handle(() async {
      await repository.convertPoints(userId, points);
      await load(userId);
    });
  }

  Future<void> withdraw(String userId, double amount) async {
    await _handle(() async {
      await repository.requestWithdrawal(userId, amount);
      await load(userId);
    });
  }

  Future<void> _handle(Future<void> Function() action) async {
    _setLoading(true);
    try {
      await action();
      errorMessage = null;
    } on AppException catch (error) {
      errorMessage = error.message;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
