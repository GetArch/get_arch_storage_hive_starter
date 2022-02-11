import 'package:protobuf/protobuf.dart' show GeneratedMessage;

typedef IMsg = GeneratedMessage;

extension IMsgExt on IMsg {
  toJson() => writeToJsonMap();

  fromJson(Map<String, dynamic> json) => mergeFromJsonMap(json);
}
// abstract class IMsg extends GeneratedMessage {
//   toJson() => writeToJsonMap();
// }
