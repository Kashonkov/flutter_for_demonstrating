sealed class AvatarEntity {}

final class FileAvatarEntity extends AvatarEntity {
  final String filePath;

  FileAvatarEntity({required this.filePath});
}

final class NetAvatarEntity extends AvatarEntity {
  final String uri;

  NetAvatarEntity({required this.uri});
}
