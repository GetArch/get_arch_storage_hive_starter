import 'package:example/src/interface/person_repo.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';
import 'const.dart';

///
/// Future包装的实例需要使用 [@preResolve]注解注入, 否则会出错
@module
abstract class StorageConfigInject {
  /// Storage Config
  /// dev和test环境不使用密码
  @dev
  @test
  @preResolve
  Future<StorageConfig> storageConfigDev(EnvConfig config) async {
    final path = config.envSign.name;
    return StorageConfig(basePath: await appSubDir(path));
  }

  /// prod 环境添加密码
  @prod
  @preResolve
  Future<StorageConfig> storageConfigProd(EnvConfig config) async {
    final path = config.envSign.name;
    return StorageConfig(
        basePath: await appSubDir(path), key: kProdStorageSecret);
  }

  /// 配置好的Storage
  @preResolve
  Future<HiveStorageString> syncStorage(StorageConfig config) async {
    final storage = HiveStorageString(config);
    await storage.preInit();
    return storage;
  }

  // ///
  // /// 同步Repo, 必须使用 [@preResolve]注解注入, 否则会出错
  // @preResolve
  // Future<PersonRepo> personRepo(StorageConfig config) async {
  //   final repo = PersonRepo(config);
  //   await repo.preInit();
  //   return repo;
  // }
}
