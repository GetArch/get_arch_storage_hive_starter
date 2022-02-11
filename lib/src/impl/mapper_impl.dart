import 'dart:convert';

import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter_interface.dart';

/// TRMapper 实现类
mixin JsStrTRMapper implements TRMapper<Map<String, dynamic>, String> {
  @override
  String cvTrans2Raw(Map<String, dynamic> transT) => json.encode(transT);

  @override
  Map<String, dynamic> cvRaw2Trans(String rawT) => json.decode(rawT);
}
