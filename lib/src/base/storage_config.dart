import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/src/constants/pubspec.yaml.g.dart'
    as spec;

///
/// 存储信息配置
class StorageConfig extends BaseConfig {
  final String basePath;
  final String? key;

  StorageConfig({
    required EnvSign sign,
    required this.basePath,
    this.key,
  }) : super(
          sign: sign,
          name: spec.name,
          version: spec.version,
          packAt: DateTime.fromMillisecondsSinceEpoch(spec.timestamp * 1000),
        );

  @override
  Map<String, dynamic> toJson() => {
        'basePath': basePath,
        'key': key,
      };
}
