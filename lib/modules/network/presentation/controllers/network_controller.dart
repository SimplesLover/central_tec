import 'package:flutter/material.dart';

import '../../../../globals/utils/app_exceptions.dart';
import '../../domain/repositories/network_repository.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/referral_entry.dart';

class NetworkController extends ChangeNotifier {
  final NetworkRepository repository;

  NetworkSummary? summary;
  List<ReferralEntry> referrals = [];
  String? errorMessage;
  bool isLoading = false;

  NetworkController({required this.repository});

  Future<void> load(String userId) async {
    await _handle(() async {
      summary = await repository.fetchNetwork(userId);
      referrals = await repository.fetchReferrals(userId);
    });
  }

  List<AppUser> get levelOne => summary?.levelOne ?? [];
  List<AppUser> get levelTwo => summary?.levelTwo ?? [];
  List<AppUser> get levelThree => summary?.levelThree ?? [];
  int get total => summary?.total ?? 0;

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
