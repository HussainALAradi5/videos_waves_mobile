import 'package:flutter/material.dart';

import 'messages_constants.dart';
import 'routes_constants.dart';

class NavDestination {
  const NavDestination({required this.route, required this.label, required this.icon, required this.selectedIcon});

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const List<NavDestination> navDestinations = [
  NavDestination(route: AppRoutes.feed, label: AppMessages.navFeed, icon: Icons.waves_outlined, selectedIcon: Icons.waves),
  NavDestination(route: AppRoutes.upload, label: AppMessages.navUpload, icon: Icons.upload_outlined, selectedIcon: Icons.upload),
  NavDestination(route: AppRoutes.profile, label: AppMessages.navProfile, icon: Icons.person_outline, selectedIcon: Icons.person),
];
