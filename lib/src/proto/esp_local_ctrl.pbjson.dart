///
//  Generated code. Do not modify.
//  source: esp_local_ctrl.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const LocalCtrlMsgType$json = const {
  '1': 'LocalCtrlMsgType',
  '2': const [
    const {'1': 'TypeCmdGetPropertyCount', '2': 0},
    const {'1': 'TypeRespGetPropertyCount', '2': 1},
    const {'1': 'TypeCmdGetPropertyValues', '2': 4},
    const {'1': 'TypeRespGetPropertyValues', '2': 5},
    const {'1': 'TypeCmdSetPropertyValues', '2': 6},
    const {'1': 'TypeRespSetPropertyValues', '2': 7},
  ],
};

const CmdGetPropertyCount$json = const {
  '1': 'CmdGetPropertyCount',
};

const RespGetPropertyCount$json = const {
  '1': 'RespGetPropertyCount',
  '2': const [
    const {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.rm_local_ctrl.Status',
      '10': 'status'
    },
    const {'1': 'count', '3': 2, '4': 1, '5': 13, '10': 'count'},
  ],
};

const PropertyInfo$json = const {
  '1': 'PropertyInfo',
  '2': const [
    const {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.rm_local_ctrl.Status',
      '10': 'status'
    },
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'type', '3': 3, '4': 1, '5': 13, '10': 'type'},
    const {'1': 'flags', '3': 4, '4': 1, '5': 13, '10': 'flags'},
    const {'1': 'value', '3': 5, '4': 1, '5': 12, '10': 'value'},
  ],
};

const CmdGetPropertyValues$json = const {
  '1': 'CmdGetPropertyValues',
  '2': const [
    const {'1': 'indices', '3': 1, '4': 3, '5': 13, '10': 'indices'},
  ],
};

const RespGetPropertyValues$json = const {
  '1': 'RespGetPropertyValues',
  '2': const [
    const {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.rm_local_ctrl.Status',
      '10': 'status'
    },
    const {
      '1': 'props',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.rm_local_ctrl.PropertyInfo',
      '10': 'props'
    },
  ],
};

const PropertyValue$json = const {
  '1': 'PropertyValue',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
};

const CmdSetPropertyValues$json = const {
  '1': 'CmdSetPropertyValues',
  '2': const [
    const {
      '1': 'props',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.rm_local_ctrl.PropertyValue',
      '10': 'props'
    },
  ],
};

const RespSetPropertyValues$json = const {
  '1': 'RespSetPropertyValues',
  '2': const [
    const {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.rm_local_ctrl.Status',
      '10': 'status'
    },
  ],
};

const LocalCtrlMessage$json = const {
  '1': 'LocalCtrlMessage',
  '2': const [
    const {
      '1': 'msg',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.rm_local_ctrl.LocalCtrlMsgType',
      '10': 'msg'
    },
    const {
      '1': 'cmd_get_prop_count',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.rm_local_ctrl.CmdGetPropertyCount',
      '9': 0,
      '10': 'cmdGetPropCount'
    },
    const {
      '1': 'resp_get_prop_count',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.rm_local_ctrl.RespGetPropertyCount',
      '9': 0,
      '10': 'respGetPropCount'
    },
    const {
      '1': 'cmd_get_prop_vals',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.rm_local_ctrl.CmdGetPropertyValues',
      '9': 0,
      '10': 'cmdGetPropVals'
    },
    const {
      '1': 'resp_get_prop_vals',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.rm_local_ctrl.RespGetPropertyValues',
      '9': 0,
      '10': 'respGetPropVals'
    },
    const {
      '1': 'cmd_set_prop_vals',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.rm_local_ctrl.CmdSetPropertyValues',
      '9': 0,
      '10': 'cmdSetPropVals'
    },
    const {
      '1': 'resp_set_prop_vals',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.rm_local_ctrl.RespSetPropertyValues',
      '9': 0,
      '10': 'respSetPropVals'
    },
  ],
  '8': const [
    const {'1': 'payload'},
  ],
};
