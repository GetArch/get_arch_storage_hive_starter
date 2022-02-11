import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

/// 是抽象类
/// 只定义接口, 还需要mixin其他的组件
abstract class BaseHiveStorage<O, T, R> extends IHiveStorage<R>
    with TRMapper<T, R>, OTRMapper<O, T, R> {
  @override
  final StorageConfig config;

  BaseHiveStorage(this.config);

  /// 上层方法, 只是为了便于使用
  O? cvRaw2ObjOr(R? raw, {O? defaultValue}) =>
      raw == null ? defaultValue : cvRaw2Obj(raw);

  Future<E> withSyncBox<E>(E Function(Box<R> syncBox) onBox) async =>
      onBox(await futureBox);

  Future<E> withSyncBoxAsync<E>(
    Future<E> Function(Box<R> syncBox) onBox,
  ) async =>
      await onBox(await futureBox);

  Future<void> saveAsync(dynamic id, O obj) async => withSyncBoxAsync(
      (syncBox) async => await syncBox.put(id, cvObj2Raw(obj)));

  Future<void> saveAllAsync(Map<dynamic, O> entries) async =>
      withSyncBoxAsync((syncBox) async => await syncBox
          .putAll(entries.map((k, v) => MapEntry(k, cvObj2Raw(v)))));

  Future<void> deleteByAsync(dynamic id, {Box<String>? specificBox}) =>
      (specificBox ?? syncBox).delete(id);

  // null 表示删除全部
  Future<void> deleteAllByAsync(Iterable<dynamic>? ids,
          {Box<String>? specificBox}) =>
      ids == null
          ? (specificBox ?? syncBox).clear()
          : (specificBox ?? syncBox).deleteAll(ids);
}

///
/// 同步box
/// 使用前务必调用 [await ::preInit()]
/// 用于存储简单的键值对
class HiveStorageString extends BaseHiveStorage<String, String, String>
    with HiveStorageSyncMx<String, String, String> {
  HiveStorageString(StorageConfig config) : super(config);

  @override
  String cvObj2Trans(String objT) => objT;

  @override
  String cvRaw2Trans(String rawT) => rawT;

  @override
  String cvTrans2Raw(String transT) => transT;

  @override
  String Function(String transT) get cvTrans2Obj => (_) => _;
}

///
/// 同步box
/// Object(IDto) -> Map<String,dynamic> -> String
/// 使用前务必调用 [await ::preInit()]
class HiveStorage<Ag extends IAgg>
    extends BaseHiveStorage<Ag, Map<String, dynamic>, String>
    with
        HiveStorageSyncMx<Ag, Map<String, dynamic>, String>,
        JsStrTRMapper,
        DtoJsStringOTRMapper<Ag> {
  @override
  final Ag Function(Map<String, dynamic> transT) cvTrans2Obj;

  HiveStorage(StorageConfig config, this.cvTrans2Obj) : super(config);
}

///
/// 异步box
/// 因为也会调用同步方法,所以混入[HiveStorageSyncMx]
class HiveAsyncStorage<Ag extends IAgg>
    extends BaseHiveStorage<Ag, Map<String, dynamic>, String>
    with
        HiveStorageSyncMx<Ag, Map<String, dynamic>, String>,
        HiveStorageASyncMx<Ag, Map<String, dynamic>, String>,
        JsStrTRMapper,
        DtoJsStringOTRMapper<Ag> {
  @override
  final Ag Function(Map<String, dynamic> transT) cvTrans2Obj;

  HiveAsyncStorage(StorageConfig config, this.cvTrans2Obj) : super(config);
}

/// mixin

/// Sync
mixin HiveStorageSyncMx<O, T, R> on BaseHiveStorage<O, T, R> {
  // save, delete 只有异步

  int size({Box<R>? specificBox}) => (specificBox ?? syncBox).length;

  bool existBy(dynamic id, {Box<R>? specificBox}) =>
      (specificBox ?? syncBox).containsKey(id);

  O? fetchBy(dynamic id, {O? defaultValue, Box<R>? specificBox}) {
    final js = (specificBox ?? syncBox).get(id);
    return cvRaw2ObjOr(js, defaultValue: defaultValue);
  }

  Iterable<O> fetchAll() => syncBox.values.map<O>((e) => cvRaw2ObjOr(e)!);
}

/// Async
mixin HiveStorageASyncMx<O, T, R> on HiveStorageSyncMx<O, T, R> {
  Future<int> sizeAsync({Box<R>? specificBox}) =>
      withSyncBox((syncBox) => size(specificBox: syncBox));

  Future<bool> existByAsync(dynamic id) async =>
      withSyncBox((syncBox) => existBy(id, specificBox: syncBox));

  Future<O?> fetchByAsync(dynamic id, {O? defaultValue}) async =>
      await withSyncBox((syncBox) => fetchBy(
            id,
            defaultValue: defaultValue,
            specificBox: syncBox,
          ));

  Future<Iterable<O>> fetchAllAsync() async =>
      await withSyncBox((syncBox) => syncBox.values.map<O>(cvRaw2Obj));

  Future<O> saveAsync(dynamic id, O obj) async => await withSyncBoxAsync(
        (syncBox) async {
          await syncBox.put(id, cvObj2Raw(obj));
          return obj;
        },
      );
}
