import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

///
/// 无需实现
/// 定义了持久化时的类型 <RawT>
/// 和获取box的方法
abstract class IHiveStorage<RawT> with IStorage<RawT> {
  StorageConfig get config;

  late final Box<RawT>? _box;

  Box<RawT> get syncBox =>
      _box ??
      (throw "Please use [await BaseHiveStorage<$runtimeType>::preInit()] to init syncBox");

  /// see [withSyncBox] [withSyncBoxAsync]
  Future<Box<RawT>> get futureBox async => _box ??= await preInit();

  // 如果在依赖注入时调用本方法,则可以使用 sync相关方法
  Future<Box<RawT>> preInit({String? fileName}) async =>
      _box = await Hive.openBox<RawT>(
        fileName ?? "$runtimeType".replaceAll(RegExp('<|>'), '_'), // 使用类名作为文件名
        path: config.basePath,
        encryptionCipher:
            config.key == null ? null : HiveAesCipher(config.key!.codeUnits),
      );
}
