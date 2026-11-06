import '../controllers/common/toast_controller.dart';

/// One toast queue for the whole app, so services and socket handlers can show toasts without a context.
final ToastController appToasts = ToastController();
