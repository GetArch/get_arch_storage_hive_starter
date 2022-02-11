part of 'dto_impl.dart';
///
/// 同步repo
/// 在进入App之前(依赖注入时)会初始化, 如果数据量过大(100MB+), 建议使用同步repo
class HiveRepo<Ag extends IAgg<Id>, Id> extends IHiveCrudRepo<Ag, Id> {
  HiveRepo(StorageConfig config, Ag Function(dynamic json) convertor)
      : super(HiveStorage<Ag>(config, convertor));
}

///
/// 异步repo
/// 在首次查询的时候初始化数据
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
