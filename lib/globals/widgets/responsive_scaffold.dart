import 'package:flutter/material.dart';

import '../constants/app_breakpoints.dart';
import '../constants/app_colors.dart';

class NavDestination {
  final String label;
  final IconData icon;
  final String route;

  const NavDestination({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;
  final List<NavDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final List<Widget> actions;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppBreakpoints.mobileMax) {
      return _buildMobile(context);
    }
    if (width < AppBreakpoints.tabletMax) {
      return _buildTablet(context, isExtended: false);
    }
    return _buildTablet(context, isExtended: true);
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...destinations.asMap().entries.map((entry) {
                final item = entry.value;
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  selected: entry.key == selectedIndex,
                  onTap: () {
                    Navigator.of(context).pop();
                    onDestinationSelected(entry.key);
                  },
                );
              }),
            ],
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _buildTablet(BuildContext context, {required bool isExtended}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: isExtended,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType:
                isExtended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
            destinations: destinations
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, color: AppColors.border),
          Expanded(child: body),
        ],
      ),
    );
  }
}
