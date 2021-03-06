// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_arch_core/get_arch_core.dart' as _i4;
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart'
    as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../interface/person_repo.dart' as _i5;
import 'hive_config.dart' as _i6;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final storageConfigInject = _$StorageConfigInject();
  await gh.factoryAsync<_i3.StorageConfig>(
      () => storageConfigInject.storageConfigDev(get<_i4.EnvConfig>()),
      registerFor: {_dev, _test},
      preResolve: true);
  await gh.factoryAsync<_i3.StorageConfig>(
      () => storageConfigInject.storageConfigProd(get<_i4.EnvConfig>()),
      registerFor: {_prod},
      preResolve: true);
  await gh.factoryAsync<_i3.HiveStorageString>(
      () => storageConfigInject.syncStorage(get<_i3.StorageConfig>()),
      preResolve: true);
  await gh.lazySingletonAsync<_i5.PersonRepo2>(
      () => _i5.PersonRepo2.inject(get<_i3.StorageConfig>()),
      preResolve: true);
  return get;
}

class _$StorageConfigInject extends _i6.StorageConfigInject {}
