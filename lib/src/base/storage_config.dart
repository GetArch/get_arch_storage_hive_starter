import 'package:get_arch_core/get_arch_core.dart';

///
/// 存储信息配置
class StorageConfig extends ValueObject implements IDto {
  final String basePath;
  final String? key;

  const StorageConfig({
    required this.basePath,
    this.key,
  });

  @override
  List<Object?> get props => [basePath, key];

  @override
  Map<String, dynamic> toJson() => {
        'basePath': basePath,
        'key': key,
      };
}
