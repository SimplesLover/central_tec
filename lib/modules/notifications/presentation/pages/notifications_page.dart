import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../globals/utils/formatters.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthController>().user;
      if (user != null) {
        context.read<NotificationController>().load(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, NotificationController>(
      builder: (context, auth, controller, child) {
        final user = auth.user;
        if (user == null) {
          return const Center(child: Text('Faça login para ver notificações'));
        }
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Notificações',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                TextButton(
                  onPressed: () => controller.markAll(user.id),
                  child: const Text('Marcar todas'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.notifications.isEmpty)
              const Center(child: Text('Nenhuma notificação'))
            else
              ...controller.notifications.map(
                (item) => Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.body),
                    trailing: Text(Formatters.dateTime.format(item.createdAt)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
