part of 'dto_impl.dart';

///
/// 同步box
/// Object(IDto) -> Map<String,dynamic> -> String
/// 使用前务必调用 [await ::preInit()]
class HiveStorage<Dto extends IDto>
    extends BaseHiveStorage<Dto, Map<String, dynamic>, String>
    with
        HiveStorageSyncMx<Dto, Map<String, dynamic>, String>,
        JsStrTRMapper,
        DtoJsStringOTRMapper<Dto> {
  @override
  final Dto Function(Map<String, dynamic> transT) cvTrans2Obj;

  HiveStorage(StorageConfig config, this.cvTrans2Obj) : super(config);
}

///
/// 异步box
/// 因为也会调用同步方法,所以混入[HiveStorageSyncMx]
class HiveAsyncStorage<Dto extends IDto>
    extends BaseHiveStorage<Dto, Map<String, dynamic>, String>
    with
        HiveStorageSyncMx<Dto, Map<String, dynamic>, String>,
        HiveStorageASyncMx<Dto, Map<String, dynamic>, String>,
        JsStrTRMapper,
        DtoJsStringOTRMapper<Dto> {
  @override
  final Dto Function(Map<String, dynamic> transT) cvTrans2Obj;

  HiveAsyncStorage(StorageConfig config, this.cvTrans2Obj) : super(config);
}