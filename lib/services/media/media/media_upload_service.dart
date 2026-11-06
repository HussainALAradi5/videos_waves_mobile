import 'package:dio/dio.dart';

import '../../../config/api/api_config.dart';
import '../../../config/api/endpoints/media_endpoints.dart';
import '../../../constants/media/media/media_messages_constants.dart';
import '../../../dtos/media/media/picked_file_dto.dart';
import '../../../enums/media/media/media_kind.dart';
import '../../../models/common/json_map.dart';
import '../../../models/media/media/media.dart';
import '../../../models/media/media/upload_signature.dart';
import '../../../utilities/errors/upload_rejected_exception.dart';
import '../../../utilities/format/media_format_utility.dart';
import '../../api/api_client.dart';

/// Uploads one file without it passing through our server: sign, upload straight to the provider
/// (ImageKit, or the local stand-in) with progress, then register so the server verifies it.
class MediaUploadService {
  MediaUploadService(this._client);

  final ApiClient _client;

  // A bare client: uploads go to the storage provider and must never carry our API token.
  final Dio _providerDio = Dio(BaseOptions(sendTimeout: ApiConfig.uploadTimeout, receiveTimeout: ApiConfig.uploadTimeout));

  Future<Media> upload(PickedFileDto file, MediaKind kind, {void Function(double progress)? onProgress}) async {
    final signature = await _client.post(MediaEndpoints.signature, UploadSignature.fromJson, body: {'kind': kind.wire});
    if (!signature.mimeTypes.contains(file.mimeType)) throw UploadRejectedException(MediaMessages.fileTypeNotAllowed(file.name));
    if (file.sizeBytes > signature.maxBytes) {
      throw UploadRejectedException(MediaMessages.fileTooLarge(file.name, formatFileSize(signature.maxBytes)));
    }
    final multipart = file.bytes != null
        ? MultipartFile.fromBytes(file.bytes!, filename: file.name, contentType: DioMediaType.parse(file.mimeType))
        : await MultipartFile.fromFile(file.path!, filename: file.name, contentType: DioMediaType.parse(file.mimeType));
    final form = FormData.fromMap({
      'fileName': file.name,
      'folder': signature.folder,
      'token': signature.token,
      'expire': '${signature.expire}',
      'signature': signature.signature,
      'publicKey': signature.publicKey,
      'isPrivateFile': '${signature.isPrivateFile}',
      'useUniqueFileName': 'true',
      'file': multipart,
    });
    final stored = await _providerDio.post<JsonMap>(
      signature.uploadUrl,
      data: form,
      onSendProgress: (sent, total) => onProgress?.call(total > 0 ? sent / total : 0),
    );
    return _client.post(MediaEndpoints.root, Media.fromJson, body: {
      'fileId': stored.data?['fileId'],
      'kind': kind.wire,
      'originalName': file.name,
    });
  }
}
