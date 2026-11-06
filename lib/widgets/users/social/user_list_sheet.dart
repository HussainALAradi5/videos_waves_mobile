import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/users/social/user_list_controller.dart';
import '../../../globals/app_dependencies.dart';
import 'user_list_view.dart';

/// Followers or following in a tall bottom sheet.
class UserListSheet extends StatefulWidget {
  const UserListSheet({super.key, required this.title, required this.fetch});

  final String title;
  final UserPageFetcher fetch;

  static Future<void> show(BuildContext context, {required String title, required UserPageFetcher fetch}) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => UserListSheet(title: title, fetch: fetch),
      );

  @override
  State<UserListSheet> createState() => _UserListSheetState();
}

class _UserListSheetState extends State<UserListSheet> {
  late final UserListController _list = UserListController(context.read<AppDependencies>().socialService, widget.fetch)..loadFirstPage();

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
        Expanded(child: UserListView(controller: _list)),
      ]),
    );
  }
}
