import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Notificações',
      button: true,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            tooltip: 'Notificações',
            onPressed: onPressed,
            icon: const Icon(Icons.notifications_outlined),
          ),
          if (count > 0)
            Container(
              margin: const EdgeInsets.only(top: 6, right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
