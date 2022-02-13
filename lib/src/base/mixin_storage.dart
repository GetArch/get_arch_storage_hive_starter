
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

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
}
