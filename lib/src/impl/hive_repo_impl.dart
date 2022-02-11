import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

///
/// 同步repo
class HiveRepo<Ag extends IAgg<Id>, Id> extends IHiveRepo<Ag, Id>
    with ICrudRepo<Ag, Id> {
  final HiveStorageSyncMx<Ag, Map<String, dynamic>, String> _storage;

  HiveRepo(StorageConfig config, Ag Function(dynamic json) convertor)
      : _storage = HiveStorage<Ag>(config, convertor);

  Future<T> init<T>() async {
    await _storage.preInit();
    return this as T;
  }

  ///
  /// 在使用实例之前, 务必调用  preInit()
  Future preInit() => _storage.preInit();

  @override
  int count() => _storage.size();

  @override
  void deleteById(Id id) => _storage.deleteByAsync(id);

  @override
  void delete(Ag entity) => _storage.deleteByAsync(entity.id);

  @override
  void deleteAllById(Iterable<Id> ids) => ids.map(deleteById);

  @override
  void deleteAll() => _storage.deleteAllByAsync(null);

  @override
  bool existsById(Id id) => _storage.existBy(id);

  @override
  Ag? findById(Id id) => _storage.fetchBy(id);

  @override
  Iterable<Ag?> findAllById(Iterable<Id> ids) => ids.map(findById);

  @override
  Iterable<Ag> findAll() => _storage.fetchAll();

  @override
  Ag save(Ag entity) {
    // save 只有异步
    _storage.saveAsync(entity.id, entity);
    return entity;
  }

  @override
  Iterable<Ag> saveAll(Iterable<Ag> entities) {
    // save 只有异步
    _storage.saveAllAsync({for (var entity in entities) entity.id: entity});
    return entities;
  }
}

class HiveAsyncRepo<Ag extends IAgg<Id>, Id> extends IHiveRepo<Ag, Id>
    with IAsyncCrudRepo<Ag, Id> {
  final HiveStorageASyncMx<Ag, Map<String, dynamic>, String> _storage;

  HiveAsyncRepo(StorageConfig config, Ag Function(dynamic json) convertor)
      : _storage = HiveAsyncStorage<Ag>(config, convertor);

  @override
  Future<Ag?> findById(Id id) async {
    return await _storage.fetchByAsync(id);
  }

  @override
  Future<Ag> save(Ag entity) async {
    _storage.saveAsync(entity.id, entity);
    return entity;
  }

  @override
  Stream<Ag> saveAllAsync(Stream<Ag> entityStream) async* {
    yield* entityStream.doOnData(save);
  }

  @override
  Stream<Ag> saveAll(Iterable<Ag> entities) async* {
    await _storage
        .saveAllAsync({for (var entity in entities) entity.id: entity});
    yield* Stream.fromIterable(entities);
  }

  @override
  Future<Ag?> findByIdAsync(Future<Id> id) async => _storage.fetchByAsync(id);

  @override
  Stream<Ag?> findAllByIdAsync(Stream<Id> idStream) async* {
    yield* idStream.map((event) => _storage.fetchBy(event));
  }

  @override
  Stream<Ag?> findAllById(Iterable<Id> ids) async* {
    yield* findAllByIdAsync(Stream.fromIterable(ids));
  }

  @override
  Stream<Ag> findAll() => Stream.fromIterable(_storage.fetchAll());

  @override
  Future<bool> existsByIdAsync(Future<Id> id) async => existsById(await id);

  @override
  Future<bool> existsById(Id id) => _storage.existByAsync(id);

  @override
  Future<void> deleteByIdAsync(Future<Id> id) async =>
      await deleteById(await id);

  @override
  Future<void> deleteById(Id id) async => await _storage.deleteByAsync(id);

  @override
  Future<void> deleteAllById(Iterable<Id> ids) async {
    for (var id in ids) {
      await _storage.deleteByAsync(id);
    }
  }

  @override
  Stream<void> deleteAllAsync(Stream<Ag> entityStream) async* {
    yield* entityStream.doOnData((event) async {
      await delete(event);
    });
  }

  @override
  Future<void> deleteAll(Iterable<Ag>? entities) =>
      _storage.deleteAllByAsync(entities?.map((e) => e.id));

  @override
  Future<void> delete(Ag entity) async => await deleteById(entity.id);

  @override
  Future<int> count() => _storage.sizeAsync();
}
