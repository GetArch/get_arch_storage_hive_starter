import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

class GetArchStorageHiveStarter extends BasePackage<StorageConfig> {
  GetArchStorageHiveStarter({
    Future<void> Function(GetIt g, StorageConfig c)? onBeforePkgInit,
    Future<void> Function(GetIt g, StorageConfig config)? onAfterPkgInit,
    Future<void> Function(StorageConfig config, Object e, StackTrace s)?
        onPkgInitError,
    Future<void> Function(StorageConfig config)? onPkgInitFinally,
    Future<void> Function(GetIt getIt, StorageConfig config)? onPackageInit,
  }) : super(
          onBeforePkgInit,
          onAfterPkgInit,
          onPkgInitError,
          onPkgInitFinally,
          onPackageInit,
        );
}
