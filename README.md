# GetArchStorageHiveStarter

## 快速开始

### 配置文件示例
通过 抽象@module 注入[StorageConfig],[HiveStorage]实现类
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

### protobuf.GenerateMessage 的持久化(注意导入的依赖包名称)
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
### 接口
1. 底层存储类型持有类  String, Uint8List ...
  [IStorage] - <RawT>
  [IHiveStorage], 继承 [IStorage],提供原始数据读写能力

2. 传输类型转换器 json(Map<String,dynamic>), byte(Uint8List) ...
  [TRMapper] - TransT
  实现类 [JsStrTRMapper]: [Map<String,dynamic>]->[String]

3. 对象转换器 Person, Student ... 
  [OTRMapper] - ObjT
  实现类 [DtoJsStringOTRMapper]: [IDo]->[Map<String,dynamic>]->[String] 

4. 能力扩展(Mx)
  [HiveStorageSyncMx]  : 同步读写方法
  [HiveStorageASyncMx] : 异步读写方法

5. Repo类
   [IHiveCrudRepo] : 对类的CRUD操作

### 实现
1. Storage实现类
  [HiveStorageString] : 只对String类作为Value进行读写
  [HiveAsyncStorage],[HiveStorage]<T extends IDto> : 对实现了IDto方法的类提供读写能力

2. Repo实现类
  [HiveCrudRepo],[HiveAsyncRepo]: 包装了对象操作的CRUD方法
