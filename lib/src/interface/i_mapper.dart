import 'package:get_arch_storage_hive_starter/get_arch_storage_hive_starter.dart';

/// TRMapper
/// 需要具体实现, 如 js->string , byte -> u8
mixin TRMapper<TransT, RawT> on IStorage<RawT> {
  RawT cvTrans2Raw(TransT transT);

  TransT cvRaw2Trans(RawT rawT);
}

/// OTRMapper
/// 可以有实现类,也可以直接混入,在实例化时传入转换方法
mixin OTRMapper<ObjT, Trans, RawT> on TRMapper<Trans, RawT> {
  ObjT Function(Trans transT) get _cvTrans2Obj;

  Trans cvObj2Trans(ObjT objT);

  RawT cvObj2Raw(ObjT objT) => cvTrans2Raw(cvObj2Trans(objT));

  ObjT cvRaw2Obj(RawT rawT) => _cvTrans2Obj(cvRaw2Trans(rawT));
}
