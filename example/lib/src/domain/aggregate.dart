import 'package:get_arch_core/get_arch_core.dart';

import 'package:json_annotation/json_annotation.dart';

part 'aggregate.g.dart';

///
/// Person 聚合根, ID类型为String
@JsonSerializable()
class Person extends IAgg<String> {
  @override
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'age')
  int age;

  Person(
    this.id,
    this.name,
    this.age,
  );

  factory Person.fromJson(Map<String, dynamic> srcJson) =>
      _$PersonFromJson(srcJson);

  @override
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
