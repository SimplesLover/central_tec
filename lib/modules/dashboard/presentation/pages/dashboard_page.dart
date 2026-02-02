import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/constants/app_colors.dart';
import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const double _chartHeight = 180;
  static const double _barMaxHeight = 160;
  static const double _barMinHeight = 20;
  static const double _barSpacing = 4;
  static const double _barRadius = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthController>();
      final user = auth.user;
      if (user != null) {
        context.read<DashboardController>().load(user.id, user.points);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, DashboardController>(
      builder: (context, auth, controller, child) {
        if (auth.user == null) {
          return const Center(child: Text('Faça login para ver o dashboard'));
        }
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage != null) {
          return Center(child: Text(controller.errorMessage!));
        }
        final stats = controller.stats;
        if (stats == null) {
          return const Center(child: Text('Sem dados disponíveis'));
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Visão geral', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _summaryGrid(stats),
            const SizedBox(height: 24),
            _chartCard('Vendas (últimos 6 meses)', stats.monthlySales),
            const SizedBox(height: 16),
            _chartCard('Comissões (últimos 6 meses)', stats.monthlyCommissionsSeries),
          ],
        );
      },
    );
  }

  Widget _summaryGrid(stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width < 700 ? 1 : width < 1000 ? 2 : 3;
        final items = [
          _summaryTile('Total de indicações', stats.totalReferrals.toString()),
          _summaryTile('Pontos', stats.points.toString()),
          _summaryTile(
            'Saldo disponível',
            Formatters.currency.format(stats.walletBalance),
          ),
          _summaryTile(
            'Comissões no mês',
            Formatters.currency.format(stats.monthlyCommissions),
          ),
          _summaryTile('Ranking', '${stats.rankingPosition}º'),
        ];
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(items.length, (index) {
            return SizedBox(
              width: columns == 1 ? width : (width - 16 * (columns - 1)) / columns,
              child: items[index],
            );
          }),
        );
      },
    );
  }

  Widget _summaryTile(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(String title, List<double> series) {
    final maxValue = _safeMaxValue(series);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: _chartHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: series
                    .map(
                      (value) => _buildChartBar(value, maxValue),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(double value, double maxValue) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _barSpacing),
        child: Container(
          height: _calculateBarHeight(value, maxValue),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(_barRadius),
          ),
        ),
      ),
    );
  }

  double _safeMaxValue(List<double> series) {
    final values = series.where((value) => value.isFinite);
    if (values.isEmpty) {
      return 1;
    }
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue : 1;
  }

  double _calculateBarHeight(double value, double maxValue) {
    final safeValue = value.isFinite && value > 0 ? value : 0;
    return (safeValue / maxValue) * _barMaxHeight + _barMinHeight;
  }
}
