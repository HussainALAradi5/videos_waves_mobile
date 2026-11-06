import '../controllers/users/auth/auth_controller.dart';
import '../interfaces/services/users/admin_request/admin_request_service_interface.dart';
import '../interfaces/services/videos/comment/comment_service_interface.dart';
import '../interfaces/services/videos/video/video_service_interface.dart';
import '../services/api/api_client.dart';
import '../services/storage/token_storage.dart';
import '../services/users/admin_request/admin_request_service.dart';
import '../services/users/auth/auth_service.dart';
import '../services/videos/comment/comment_service.dart';
import '../services/videos/video/video_service.dart';

/// Builds the object graph once at startup: one API client shared by every service.
class AppDependencies {
  AppDependencies._({
    required this.authController,
    required this.videoService,
    required this.commentService,
    required this.adminRequestService,
  });

  factory AppDependencies.create() {
    final tokenStorage = TokenStorage();
    late final AuthController authController;
    // The client reports failed refreshes to the auth controller, which is created right after it.
    final client = ApiClient(tokenStorage: tokenStorage, onSessionExpired: () => authController.handleSessionExpired());
    authController = AuthController(AuthService(client), tokenStorage);
    return AppDependencies._(
      authController: authController,
      videoService: VideoService(client),
      commentService: CommentService(client),
      adminRequestService: AdminRequestService(client),
    );
  }

  final AuthController authController;
  final VideoServiceInterface videoService;
  final CommentServiceInterface commentService;
  final AdminRequestServiceInterface adminRequestService;
}
