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
