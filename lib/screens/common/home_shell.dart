import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/common/navigation_constants.dart';
import '../../constants/common/routes_constants.dart';
import '../../controllers/chat/realtime/chat_socket_controller.dart';
import '../../widgets/common/waves/wave_background.dart';

/// Five tabs (Home, Search, Upload, Messages with its unread badge, Profile) over the wave backdrop.
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
    final unread = context.select<ChatSocketController, int>((chat) => chat.unreadCount);
    return Scaffold(
      body: Stack(children: [const Positioned.fill(child: WaveBackground()), child]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => context.go(navDestinations[index].route),
        destinations: [
          for (var index = 0; index < navDestinations.length; index++)
            NavigationDestination(
              icon: Badge(
                isLabelVisible: index == messagesTabIndex && unread > 0,
                label: Text('$unread'),
                child: Icon(navDestinations[index].icon),
              ),
              selectedIcon: Icon(navDestinations[index].selectedIcon),
              label: navDestinations[index].label,
            ),
        ],
      ),
    );
  }
}
