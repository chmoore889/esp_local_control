///
//  Generated code. Do not modify.
//  source: esp_local_ctrl.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class LocalCtrlMsgType extends $pb.ProtobufEnum {
  static const LocalCtrlMsgType TypeCmdGetPropertyCount = LocalCtrlMsgType._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'TypeCmdGetPropertyCount');
  static const LocalCtrlMsgType TypeRespGetPropertyCount = LocalCtrlMsgType._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'TypeRespGetPropertyCount');
  static const LocalCtrlMsgType TypeCmdGetPropertyValues = LocalCtrlMsgType._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'TypeCmdGetPropertyValues');
  static const LocalCtrlMsgType TypeRespGetPropertyValues = LocalCtrlMsgType._(
      5,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'TypeRespGetPropertyValues');
  static const LocalCtrlMsgType TypeCmdSetPropertyValues = LocalCtrlMsgType._(
      6,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'TypeCmdSetPropertyValues');
  static const LocalCtrlMsgType TypeRespSetPropertyValues = LocalCtrlMsgType._(
      7,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'TypeRespSetPropertyValues');

  static const $core.List<LocalCtrlMsgType> values = <LocalCtrlMsgType>[
    TypeCmdGetPropertyCount,
    TypeRespGetPropertyCount,
    TypeCmdGetPropertyValues,
    TypeRespGetPropertyValues,
    TypeCmdSetPropertyValues,
    TypeRespSetPropertyValues,
  ];

  static final $core.Map<$core.int, LocalCtrlMsgType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static LocalCtrlMsgType? valueOf($core.int value) => _byValue[value];

  const LocalCtrlMsgType._($core.int v, $core.String n) : super(v, n);
}
