# Videos Waves — Mobile app

Flutter client for Videos Waves: an infinite feed with search, video playback, likes, comments, uploads from the device, sign-in, and admin requests and reviews.

**Stack:** Flutter 3.47 / Dart 3.13, provider (ChangeNotifier controllers), go_router, Dio, flutter_secure_storage, video_player, file_picker, intl.

Related repositories: [server](../videos_waves_server) · [web client](../videos_waves_client) · [documentation](../videos_waves_documentation)

## Run

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

`API_BASE_URL` is the server origin and is read at build time:

| Target | Value |
| --- | --- |
| Android emulator (default) | `http://10.0.2.2:5000` |
| iOS simulator | `http://localhost:5000` |
| Physical device | `http://<your computer's LAN IP>:5000` |
| Release | An `https://` origin. Android blocks cleartext HTTP in release builds |
| Web build | Also add the page origin to the server's `CORS_ORIGINS` |

| Command | What it does |
| --- | --- |
| `flutter analyze` | Static analysis (stricter lints in `analysis_options.yaml`) |
| `flutter test` | Unit and widget tests |
| `flutter build apk --debug` | Android debug build |

## Layout

```text
lib/
  config/        API config, endpoint map mirroring the server routes, router + guard, theme
  constants/     UI text, routes, limits, spacing/colors, storage keys, enum label maps
  enums/         role, admin request status, error code, auth status, sort direction
  models/        User, Video, Comment, AdminRequest, page metadata (map wire JSON once)
  dtos/          request DTOs and the auth session
  interfaces/    service contracts (fakes implement them in tests)
  services/      one Dio ApiClient, token storage, a service per resource
  middlewares/   Dio interceptors: auth + single refresh, error mapping
  controllers/   ChangeNotifier state; PagedListController<T> is shared by every list
  validations/   form rules mirroring the server
  utilities/     ApiException, formatters, snack-bar feedback
  widgets/       reusable widgets (common/, videos/, users/)
  screens/       one folder per screen
  globals/       AppDependencies: the object graph built once at startup
test/            mirrors lib/
```

Widgets only render; data and actions come from controllers. No widget file is longer than 150 lines, and strings, colors, and sizes come from `constants/`.

## Reusable widgets

| Widget | Purpose |
| --- | --- |
| `PagedListView<T>` | Any server-paged list: pull to refresh, infinite loading, and loading, error, and empty states |
| `LoadingView`, `EmptyView`, `ErrorView` | Shared feedback states (with retry) |
| `AppTextField`, `SubmitButton` | Form input and a submit button with a busy state |
| `ConfirmDialog.show` | Confirmation for destructive actions |
| `StatusChip` | Any enum value with its label and color from one map |
| `UserAvatar`, `ConstrainedContent` | Avatar with initials fallback; readable width on tablets |

## Security

Tokens are stored with `flutter_secure_storage` (Keychain on iOS, the Keystore on Android). A 401 triggers one queued refresh and a single retry. If the refresh fails, the session is cleared and the app shows "session expired". Route guards only improve the UI; the API enforces every permission.
