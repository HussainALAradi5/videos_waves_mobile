import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/common/messages_constants.dart';
import '../../../controllers/users/admin_request/admin_request_list_controller.dart';
import '../../../enums/users/admin_request/admin_request_status.dart';
import '../../../globals/app_dependencies.dart';
import '../../../utilities/ui/feedback_utility.dart';
import '../../../widgets/common/feedback/empty_view.dart';
import '../../../widgets/common/layout/constrained_content.dart';
import '../../../widgets/common/lists/paged_list_view.dart';
import '../../../widgets/users/admin_request/admin_request_tile.dart';

/// Admins review pending requests. The router keeps non-admins out; the API enforces it.
class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminRequestListController(context.read<AppDependencies>().adminRequestService)..loadFirstPage(),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppMessages.adminRequestsTitle)),
        body: Consumer<AdminRequestListController>(
          builder: (context, controller, _) => ConstrainedContent(
            child: PagedListView(
              controller: controller,
              empty: const EmptyView(title: AppMessages.noAdminRequests, icon: Icons.inbox_outlined),
              itemBuilder: (context, request) => AdminRequestTile(
                request: request,
                isBusy: controller.decidingId == request.id,
                onAccept: () => runWithFeedback(context, () => controller.decide(request, AdminRequestStatus.accepted)),
                onReject: () => runWithFeedback(context, () => controller.decide(request, AdminRequestStatus.rejected)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
