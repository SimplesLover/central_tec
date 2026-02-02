import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'globals/services/service_locator.dart';
import 'globals/theme/app_theme.dart';
import 'globals/widgets/app_shell.dart';
import 'modules/auth/presentation/controllers/auth_controller.dart';
import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/auth/presentation/pages/profile_page.dart';
import 'modules/auth/presentation/pages/register_page.dart';
import 'modules/cart/presentation/controllers/cart_controller.dart';
import 'modules/cart/presentation/pages/cart_page.dart';
import 'modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'modules/dashboard/presentation/pages/dashboard_page.dart';
import 'modules/network/presentation/controllers/network_controller.dart';
import 'modules/network/presentation/pages/network_page.dart';
import 'modules/notifications/presentation/controllers/notification_controller.dart';
import 'modules/notifications/presentation/pages/notifications_page.dart';
import 'modules/orders/presentation/controllers/order_controller.dart';
import 'modules/orders/presentation/pages/checkout_page.dart';
import 'modules/orders/presentation/pages/history_page.dart';
import 'modules/products/presentation/controllers/product_controller.dart';
import 'modules/products/presentation/pages/product_detail_page.dart';
import 'modules/products/presentation/pages/products_page.dart';
import 'modules/wallet/presentation/controllers/wallet_controller.dart';
import 'modules/wallet/presentation/pages/wallet_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  final authController = AuthController(repository: serviceLocator());
  await authController.loadSession();
  runApp(MyApp(authController: authController));
}

class MyApp extends StatelessWidget {
  final AuthController authController;

  const MyApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
        ChangeNotifierProvider(
          create: (_) => NotificationController(repository: serviceLocator()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductController(repository: serviceLocator()),
        ),
        ChangeNotifierProvider(
          create: (_) => CartController(repository: serviceLocator()),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderController(repository: serviceLocator()),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletController(repository: serviceLocator()),
        ),
        ChangeNotifierProvider(
          create: (_) => NetworkController(repository: serviceLocator()),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardController(repository: serviceLocator()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Centraltec MMN',
        theme: AppTheme().buildTheme(),
        routerConfig: _router(authController),
      ),
    );
  }
}

GoRouter _router(AuthController authController) {
  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: authController,
    redirect: (context, state) {
      final loggedIn = authController.user != null;
      final loggingIn =
          state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (!loggedIn && !loggingIn) {
        return '/login';
      }
      if (loggedIn && loggingIn) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) =>
                ProductDetailPage(productId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: '/checkout',
            builder: (context, state) => const CheckoutPage(),
          ),
          GoRoute(
            path: '/network',
            builder: (context, state) => const NetworkPage(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
        ],
      ),
    ],
  );
}
