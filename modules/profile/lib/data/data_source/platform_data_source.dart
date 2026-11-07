import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:profile/domain/entity/avatar_source.dart';

abstract interface class PlatformDataSource {
  Future<String?> getAppVersion();

  Future<String?> getAvatar(AvatarSource source);
}

final class PlatformDataSourceImpl implements PlatformDataSource {
  @override
  Future<String?> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<String?> getAvatar(AvatarSource source) async {
    final ImageSource imgSource;
    switch (source) {
      case AvatarSource.gallery:
        imgSource = ImageSource.gallery;
      case AvatarSource.camera:
        imgSource = ImageSource.camera;
    }
    final picker = ImagePicker();
    XFile? picture = await picker.pickImage(source: imgSource);
    return picture?.path;
  }
}
