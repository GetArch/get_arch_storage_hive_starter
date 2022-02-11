part of 'protobuf_impl.dart';

///
/// 对 protobuf GeneratedMessage 的实现
///
/// 同步box
/// Object(IDto) -> Map<String,dynamic> -> String
/// 使用前务必调用 [await ::preInit()]
class HiveStorage<Msg extends IMsg>
    extends BaseHiveStorage<Msg, Map<String, dynamic>, String>
    with
        HiveStorageSyncMx<Msg, Map<String, dynamic>, String>,
        JsStrTRMapper,
        MsgJsStringOTRMapper<Msg> {
  @override
  final Msg Function(String rawT) cvRaw2Obj;

  HiveStorage(StorageConfig config, this.cvRaw2Obj) : super(config);

  /// protobuf 直接生成 raw2Obj方法, 因此直接传入 [cvRaw2Obj],而不是[cvTrans2Obj]
  @override
  Msg Function(Map<String, dynamic> transT) get cvTrans2Obj =>
      (t) => cvRaw2Obj(cvTrans2Raw(t));
}

///
/// 异步box
/// 因为也会调用同步方法,所以混入[HiveStorageSyncMx]
class HiveAsyncStorage<Msg extends IMsg>
    extends BaseHiveStorage<Msg, Map<String, dynamic>, String>
    with
        HiveStorageSyncMx<Msg, Map<String, dynamic>, String>,
        HiveStorageASyncMx<Msg, Map<String, dynamic>, String>,
        JsStrTRMapper,
        MsgJsStringOTRMapper<Msg> {
  @override
  final Msg Function(Map<String, dynamic> transT) cvTrans2Obj;

  HiveAsyncStorage(StorageConfig config, this.cvTrans2Obj) : super(config);
}
