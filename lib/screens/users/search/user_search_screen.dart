import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/ui_constants.dart';
import '../../../constants/users/social/social_messages_constants.dart';
import '../../../controllers/users/social/user_list_controller.dart';
import '../../../globals/app_dependencies.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/users/social/user_list_view.dart';

/// Find people by name, with Follow buttons inline.
class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  late final UserListController _results = () {
    final social = context.read<AppDependencies>().socialService;
    return UserListController(social, social.search)..loadFirstPage();
  }();

  @override
  void dispose() {
    _results.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(SocialMessages.searchTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.md, 0, Spacing.md, Spacing.sm),
            child: TextField(
              autofocus: false,
              onChanged: _results.setSearch,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: SocialMessages.searchHint, isDense: true),
            ),
          ),
        ),
      ),
      body: ConstrainedContent(
        child: UserListView(
          controller: _results,
          empty: const EmptyView(title: SocialMessages.searchPrompt, icon: Icons.travel_explore),
        ),
      ),
    );
  }
}
