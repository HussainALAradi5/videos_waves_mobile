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
  NavDestination(route: AppRoutes.feed, label: AppMessages.navFeed, icon: Icons.home_outlined, selectedIcon: Icons.home_rounded),
  NavDestination(route: AppRoutes.search, label: AppMessages.navSearch, icon: Icons.search, selectedIcon: Icons.manage_search),
  NavDestination(route: AppRoutes.upload, label: AppMessages.navUpload, icon: Icons.add_box_outlined, selectedIcon: Icons.add_box),
  NavDestination(route: AppRoutes.messages, label: AppMessages.navMessages, icon: Icons.chat_bubble_outline, selectedIcon: Icons.chat_bubble),
  NavDestination(route: AppRoutes.profile, label: AppMessages.navProfile, icon: Icons.person_outline, selectedIcon: Icons.person),
];

/// Index of the Messages tab, which carries the unread badge.
const int messagesTabIndex = 3;
