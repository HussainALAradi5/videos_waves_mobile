import '../controllers/chat/realtime/chat_socket_controller.dart';
import '../controllers/users/auth/auth_controller.dart';
import '../controllers/users/settings/settings_controller.dart';
import '../interfaces/services/users/admin_request/admin_request_service_interface.dart';
import '../interfaces/services/videos/comment/comment_service_interface.dart';
import '../interfaces/services/videos/video/video_service_interface.dart';
import '../services/api/api_client.dart';
import '../services/chat/conversation/conversation_service.dart';
import '../services/chat/message/message_service.dart';
import '../services/media/media/media_upload_service.dart';
import '../services/notifications/notification_service.dart';
import '../services/realtime/socket_service.dart';
import '../services/storage/preferences_storage.dart';
import '../services/storage/token_storage.dart';
import '../services/users/admin_request/admin_request_service.dart';
import '../services/users/auth/auth_service.dart';
import '../services/users/settings/settings_service.dart';
import '../services/users/social/social_service.dart';
import '../services/videos/comment/comment_service.dart';
import '../services/videos/video/video_service.dart';

/// Builds the object graph once at startup: one API client and one socket shared by every service.
class AppDependencies {
  AppDependencies._({
    required this.authController,
    required this.settingsController,
    required this.chatSocketController,
    required this.notificationService,
    required this.videoService,
    required this.commentService,
    required this.adminRequestService,
    required this.mediaUploadService,
    required this.socialService,
    required this.settingsService,
    required this.conversationService,
    required this.messageService,
    required this.socketService,
    required this.apiClient,
  });

  factory AppDependencies.create() {
    final tokenStorage = TokenStorage();
    late final AuthController authController;
    // The client reports rejected refreshes to the auth controller, which is created right after it.
    final client = ApiClient(tokenStorage: tokenStorage, onSessionExpired: () => authController.handleSessionExpired());
    authController = AuthController(AuthService(client), tokenStorage);
    final settingsService = SettingsService(client);
    final conversationService = ConversationService(client);
    final socketService = SocketService(tokenStorage);
    final notificationService = NotificationService(client);
    final settingsController = SettingsController(settingsService, authController, PreferencesStorage());
    return AppDependencies._(
      authController: authController,
      settingsController: settingsController,
      chatSocketController: ChatSocketController(authController, socketService, conversationService, notificationService, settingsController),
      notificationService: notificationService,
      videoService: VideoService(client),
      commentService: CommentService(client),
      adminRequestService: AdminRequestService(client),
      mediaUploadService: MediaUploadService(client),
      socialService: SocialService(client),
      settingsService: settingsService,
      conversationService: conversationService,
      messageService: MessageService(client),
      socketService: socketService,
      apiClient: client,
    );
  }

  final AuthController authController;
  final SettingsController settingsController;
  final ChatSocketController chatSocketController;
  final NotificationService notificationService;
  final VideoServiceInterface videoService;
  final CommentServiceInterface commentService;
  final AdminRequestServiceInterface adminRequestService;
  final MediaUploadService mediaUploadService;
  final SocialService socialService;
  final SettingsService settingsService;
  final ConversationService conversationService;
  final MessageService messageService;
  final SocketService socketService;
  final ApiClient apiClient;
}
