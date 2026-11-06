import 'package:flutter/foundation.dart';

import '../../../dtos/common/pagination/page_request_dto.dart';
import '../../../interfaces/services/users/admin_request/admin_request_service_interface.dart';
import '../../../models/users/admin_request/admin_request.dart';

/// The signed-in user's own latest request (the API returns only the caller's requests).
class MyAdminRequestController extends ChangeNotifier {
  MyAdminRequestController(this._service);

  static const PageRequestDto _latestOnly = PageRequestDto(page: 1, pageSize: 1);

  final AdminRequestServiceInterface _service;

  AdminRequest? latest;
  bool isLoading = true;
  bool isSubmitting = false;
  Object? error;

  bool get canRequest => latest == null || !latest!.isPending;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final page = await _service.list(_latestOnly);
      latest = page.items.isEmpty ? null : page.items.first;
    } catch (caught) {
      error = caught;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> create(String reason) => _submit(() => _service.create(reason.trim()));

  Future<void> cancel() => _submit(() => _service.cancel(latest!.id));

  Future<void> _submit(Future<AdminRequest> Function() action) async {
    isSubmitting = true;
    notifyListeners();
    try {
      latest = await action();
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
