import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

///
/// 同步box
/// 使用前务必调用 [await ::preInit()]
/// 用于存储简单的键值对
class HiveStorageString extends BaseHiveStorage<String, String, String>
    with HiveStorageSyncMx<String, String, String> {
  HiveStorageString(StorageConfig config) : super(config);

  @override
  String Function(String obj) get cvObj2Trans => (_) => _;

  @override
  String cvRaw2Trans(String rawT) => rawT;

  @override
  String cvTrans2Raw(String transT) => transT;

  @override
  String Function(String transT) get cvTrans2Obj => (_) => _;
}
