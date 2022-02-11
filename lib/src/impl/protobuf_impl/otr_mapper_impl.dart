part of 'protobuf_impl.dart';

/// OTRMapper 实现类
mixin MsgJsStringOTRMapper<DTO extends IMsg>
    on OTRMapper<DTO, Map<String, dynamic>, String> {
  @override
  Map<String, dynamic> Function(DTO objT) get cvObj2Trans => (_) => _.toJson();
}
