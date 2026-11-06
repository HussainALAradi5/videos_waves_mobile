import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/common/navigation_constants.dart';
import '../../constants/common/routes_constants.dart';

/// Bottom navigation around the feed, upload, and profile tabs.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  int get _selectedIndex {
    final index = navDestinations.lastIndexWhere(
      (destination) => destination.route == AppRoutes.feed ? location == AppRoutes.feed : location.startsWith(destination.route),
    );
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => context.go(navDestinations[index].route),
        destinations: [
          for (final destination in navDestinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}
