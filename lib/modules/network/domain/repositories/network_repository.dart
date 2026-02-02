import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/referral_entry.dart';

class NetworkSummary {
  final List<AppUser> levelOne;
  final List<AppUser> levelTwo;
  final List<AppUser> levelThree;

  const NetworkSummary({
    required this.levelOne,
    required this.levelTwo,
    required this.levelThree,
  });

  int get total => levelOne.length + levelTwo.length + levelThree.length;
}

abstract class NetworkRepository {
  Future<NetworkSummary> fetchNetwork(String userId);
  Future<List<ReferralEntry>> fetchReferrals(String userId);
}
