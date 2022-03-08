import 'package:flutter/foundation.dart';
import 'package:get_arch_core/get_arch_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

const kAppName = "hive_starter_demo";
const kPackageVersion = '1.0.0';
final kPackAt = DateTime(2022, 2, 11);

final kEnvDev = GetArchCoreConfig(sign: EnvSign.dev);
final kEnvTest = GetArchCoreConfig(sign: EnvSign.test);
final kEnvProd = GetArchCoreConfig(sign: EnvSign.prod);

const kProdStorageSecret = "sd1fg3sq4we9rb4shh2tj6as2er1glo5n";

/// 本地存储-文件路径
const _kRootSubDir = "GetArch";

Future<String> fullPathWrap(String path) async {
  if (kIsWeb) return path;
  return getApplicationDocumentsDirectory()
      .then((value) => join(value.path, path));
}

//
final _appCoreSubDir = join(_kRootSubDir, kAppName);

// context: dev, test, prod
Future<String> appSubDir(String context) =>
    fullPathWrap(join(_appCoreSubDir, context));
