class DashboardStats {
  final int totalReferrals;
  final int points;
  final double walletBalance;
  final double monthlyCommissions;
  final int rankingPosition;
  final List<double> monthlySales;
  final List<double> monthlyCommissionsSeries;

  const DashboardStats({
    required this.totalReferrals,
    required this.points,
    required this.walletBalance,
    required this.monthlyCommissions,
    required this.rankingPosition,
    required this.monthlySales,
    required this.monthlyCommissionsSeries,
  });
}
