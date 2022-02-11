# GetArchStorageHiveStarter

## 快速开始
### 配置文件示例
```dart
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
}
```

### 持久化 protobuf.GenerateMessage
```dart
import 'package:commerce_client/src/generated/user.pb.dart';
// 注意导入的依赖
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_protobuf_impl.dart';

// [TokenInfoRsp] 是通过 proto生成的,GenerateMessage实现类
class TokenStorage extends HiveStorage<TokenInfoRsp> {
  TokenStorage(StorageConfig config) : super(config, TokenInfoRsp.fromJson);
}
```

## 介绍

1. 底层存储类型  String, Uint8List ...
  [HiveStorageMx] - RawT

2. 传输类型 json(Map<String,dynamic>), byte(Uint8List) ...
  [TRMapper] - TransT,
  具体实现类 [JsStrTRMapper]

3. 对象类型 Person, User ...
