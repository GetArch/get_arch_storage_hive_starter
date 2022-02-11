part of 'dto_impl.dart';

/// OTRMapper 实现类
mixin DtoJsStringOTRMapper<DTO extends IDto>
    on OTRMapper<DTO, Map<String, dynamic>, String> {
  @override
  Map<String, dynamic> Function(DTO objT) get cvObj2Trans => (_) => _.toJson();
}
