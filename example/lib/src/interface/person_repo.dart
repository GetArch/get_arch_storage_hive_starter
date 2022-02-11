import 'package:example/src/domain/aggregate.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

///
/// 继承自同步repo, 在注入时需要 preInit()
/// 详见 hive_config.dart ::personRepo 方法
class PersonRepo extends HiveRepo<Person, String> {
  PersonRepo(StorageConfig config) : super(config, (js) => Person.fromJson(js));
}

///
/// 使用静态方法注入
@preResolve
@lazySingleton
class PersonRepo2 extends HiveRepo<Person, String> {
  PersonRepo2(StorageConfig config, Person Function(dynamic json) convertor)
      : super(config, convertor);

  ///
  /// 对静态的注入方法添加 @factoryMethod 注解
  @factoryMethod
  static Future<PersonRepo2> inject(StorageConfig config) async =>
      PersonRepo2(config, (json) => Person.fromJson(json)).init<PersonRepo2>();
}
