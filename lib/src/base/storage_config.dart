import 'package:get_arch_core/get_arch_core.dart';

///
/// 存储信息配置
class StorageConfig extends BaseConfig {
  final String basePath;
  final String? key;

  StorageConfig(this.basePath, this.key,
      {required EnvSign sign,
      required String name,
      required String version,
      required DateTime packAt})
      : super(sign: sign, name: name, version: version, packAt: packAt);

  // const StorageConfig({
  //   required this.basePath,
  //   this.key,
  // });

  @override
  List<Object?> get props => [basePath, key];

  @override
  Map<String, dynamic> toJson() => {
        'basePath': basePath,
        'key': key,
      };
}
