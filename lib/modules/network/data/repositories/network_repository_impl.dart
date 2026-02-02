import '../../../../globals/constants/app_constants.dart';
import '../../../../globals/services/app_logger.dart';
import '../../../../globals/utils/app_exceptions.dart';
import '../../../core/domain/entities/app_user.dart';
import '../../../core/domain/entities/referral_entry.dart';
import '../../domain/repositories/network_repository.dart';
import '../datasources/network_local_datasource.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final NetworkLocalDataSource dataSource;
  final AppLogger logger;

  const NetworkRepositoryImpl({
    required this.dataSource,
    required this.logger,
  });

  @override
  Future<NetworkSummary> fetchNetwork(String userId) async {
    try {
      final users = await dataSource.fetchUsers();
      final map = {for (final user in users) user.id: user};
      final levelOne = _levelOne(userId, map);
      final levelTwo = _levelTwo(levelOne, map);
      final levelThree = _levelThree(levelTwo, map);
      return NetworkSummary(
        levelOne: levelOne,
        levelTwo: levelTwo,
        levelThree: levelThree,
      );
    } catch (error) {
      logger.error('Falha ao carregar rede');
      throw const AppException('Não foi possível carregar a rede');
    }
  }

  @override
  Future<List<ReferralEntry>> fetchReferrals(String userId) async {
    try {
      return await dataSource.fetchReferrals(userId);
    } catch (error) {
      logger.error('Falha ao carregar indicações');
      throw const AppException('Não foi possível carregar indicações');
    }
  }

  List<AppUser> _levelOne(String userId, Map<String, AppUser> map) {
    return _findByReferrer(userId, map.values.toList());
  }

  List<AppUser> _levelTwo(List<AppUser> levelOne, Map<String, AppUser> map) {
    if (AppConstants.maxNetworkLevels < 2) {
      return [];
    }
    return _expand(levelOne, map);
  }

  List<AppUser> _levelThree(List<AppUser> levelTwo, Map<String, AppUser> map) {
    if (AppConstants.maxNetworkLevels < 3) {
      return [];
    }
    return _expand(levelTwo, map);
  }

  List<AppUser> _expand(List<AppUser> parents, Map<String, AppUser> map) {
    final result = <AppUser>[];
    for (final parent in parents) {
      result.addAll(_findByReferrer(parent.id, map.values.toList()));
    }
    return result;
  }

  List<AppUser> _findByReferrer(String userId, List<AppUser> users) {
    final referrer = users.where((user) => user.id == userId).toList();
    if (referrer.isEmpty) {
      return [];
    }
    final code = referrer.first.referralCode;
    return users.where((user) => user.referredByCode == code).toList();
  }
}
