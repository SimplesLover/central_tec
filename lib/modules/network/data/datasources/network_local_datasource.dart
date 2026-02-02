import '../../../../globals/services/in_memory_database.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/referral_entry.dart';

class NetworkLocalDataSource {
  final InMemoryDatabase database;

  const NetworkLocalDataSource({required this.database});

  Future<List<ReferralEntry>> fetchReferrals(String userId) async {
    return database.referrals
        .where((item) => item.referrerId == userId)
        .toList();
  }

  Future<List<AppUser>> fetchUsers() async {
    return database.users.toList();
  }
}
