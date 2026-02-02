import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../../modules/auth/presentation/controllers/auth_controller.dart';
import '../../modules/notifications/presentation/controllers/notification_controller.dart';
import 'notification_badge.dart';
import 'responsive_scaffold.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String? _lastUserId;

  @override
  Widget build(BuildContext context) {
    _loadNotifications(context);
    final destinations = _destinations();
    final location = GoRouterState.of(context).matchedLocation;
    final selected = _selectedIndex(location, destinations);
    return ResponsiveScaffold(
      title: AppConstants.appName,
      selectedIndex: selected,
      destinations: destinations,
      onDestinationSelected: (index) {
        context.go(destinations[index].route);
      },
      actions: [
        Consumer<NotificationController>(
          builder: (context, controller, child) {
            return NotificationBadge(
              count: controller.unreadCount,
              onPressed: () {
                context.go('/notifications');
              },
            );
          },
        ),
      ],
      body: widget.child,
    );
  }

  void _loadNotifications(BuildContext context) {
    final authController = context.read<AuthController>();
    final userId = authController.user?.id;
    if (userId == null || userId == _lastUserId) {
      return;
    }
    _lastUserId = userId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationController>().load(userId);
      }
    });
  }

  List<NavDestination> _destinations() {
    return const [
      NavDestination(label: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
      NavDestination(label: 'Produtos', icon: Icons.storefront, route: '/products'),
      NavDestination(label: 'Carrinho', icon: Icons.shopping_cart, route: '/cart'),
      NavDestination(label: 'Rede', icon: Icons.hub, route: '/network'),
      NavDestination(label: 'Carteira', icon: Icons.account_balance_wallet, route: '/wallet'),
      NavDestination(label: 'Histórico', icon: Icons.receipt_long, route: '/history'),
      NavDestination(label: 'Perfil', icon: Icons.person, route: '/profile'),
    ];
  }

  int _selectedIndex(String location, List<NavDestination> destinations) {
    final index = destinations.indexWhere((item) => location.startsWith(item.route));
    return index < 0 ? 0 : index;
  }
}
