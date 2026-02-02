import '../constants/app_constants.dart';

class CommissionService {
  double levelOne(double total) => total * AppConstants.levelOneCommission;
  double levelTwo(double total) => total * AppConstants.levelTwoCommission;
  double levelThree(double total) => total * AppConstants.levelThreeCommission;
  double cashback(double total) => total * AppConstants.cashbackRate;
}
