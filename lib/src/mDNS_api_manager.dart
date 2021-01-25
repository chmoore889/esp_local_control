import 'dart:convert';
import 'dart:typed_data';

import 'package:esp_rainmaker_local_control/src/esp_local_control_base.dart';
import 'package:esp_rainmaker_local_control/src/proto/constants.pb.dart';
import 'package:esp_rainmaker_local_control/src/proto/esp_local_ctrl.pb.dart';
import 'package:http/http.dart';
import 'package:isolate_json/isolate_json.dart';
import 'package:protobuf/protobuf.dart';

class MDNSApiManager {
  static const String path = '/esp_local_ctrl/control';

  Client client;

  MDNSApiManager() {
    client = Client();
  }

  void dispose() {
    client.close();
  }

  Future<Map<String, dynamic>> getNodeDetails(String url) async {
    final count = await getPropertyCount(url, path);
    //print(count);
    final data = await getPropertyValues(url, path, count);
    return data['config'];
  }

  Future<Map<String, dynamic>> getParamsValues(String url) async {
    final count = await getPropertyCount(url, path);
    //print(count);
    final data = await getPropertyValues(url, path, count);
    return data['params'];
  }

  Future<void> updateParamValue(String url, Map<String, dynamic> body) async {
    final jsonData = await JsonIsolate().encodeJson(body);
    final data = _createSetPropertyInfoRequest(jsonData);

    final returnData = await _sendRequest(url + path, data);
    if (returnData != null) {
      final response = LocalCtrlMessage.fromBuffer(returnData);
      final status = response.respSetPropVals.status;

      if (status == Status.Success) {
        return;
      } else {
        throw LocalControlFailed();
      }
    } else {
      throw LocalControlFailed();
    }
  }

  Future<int> getPropertyCount(String url, String path) async {
    final data = _createGetPropertyCountRequest();

    final returnData = await _sendRequest(url + path, data);
    if (returnData != null) {
      final count = _processGetPropertyCount(returnData);
      return count;
    } else {
      throw LocalControlFailed();
    }
  }

  Future<Map<String, dynamic>> getPropertyValues(
      String url, String path, int count) async {
    final data = _createGetAllPropertyValuesRequest(count);

    final returnData = await _sendRequest(url + path, data);
    if (returnData != null) {
      return await _processGetPropertyValue(returnData);
    } else {
      throw LocalControlFailed();
    }
  }

  Uint8List _createGetPropertyCountRequest() {
    final msgType = LocalCtrlMsgType.TypeCmdGetPropertyCount;
    final msg = LocalCtrlMessage()
      ..msg = msgType
      ..cmdGetPropCount = CmdGetPropertyCount();

    return msg.writeToBuffer();
  }

  Uint8List _createSetPropertyInfoRequest(String jsonData) {
    final msgType = LocalCtrlMsgType.TypeCmdSetPropertyValues;
    final prop = PropertyValue()
      ..index = 1
      ..value = utf8.encode(jsonData);

    final payload = CmdSetPropertyValues()..props.add(prop);

    final msg = LocalCtrlMessage()
      ..msg = msgType
      ..cmdSetPropVals = payload;

    return msg.writeToBuffer();
  }

  Uint8List _createGetAllPropertyValuesRequest(int count) {
    final indices = List.generate(count, (index) => index);

    final msgType = LocalCtrlMsgType.TypeCmdGetPropertyValues;
    final payload = CmdGetPropertyValues()..indices.addAll(indices);

    final msg = LocalCtrlMessage()
      ..msg = msgType
      ..cmdGetPropVals = payload;

    return msg.writeToBuffer();
  }

  int _processGetPropertyCount(Uint8List returnData) {
    var count = 0;

    try {
      final response = LocalCtrlMessage.fromBuffer(returnData);

      if (response.respGetPropCount.status == Status.Success) {
        count = response.respGetPropCount.count;
      }
    } on InvalidProtocolBufferException catch (e) {
      print(e);
      throw LocalControlFailed();
    }
    return count;
  }

  Future<Map<String, dynamic>> _processGetPropertyValue(Uint8List returnData) async {
    try {
      final response = LocalCtrlMessage.fromBuffer(returnData);

      if (response.respGetPropVals.status == Status.Success) {
        final propertyInfoList = response.respGetPropVals.props;

        final bundle = <String, dynamic>{};

        for (final propertyInfo in propertyInfoList) {
          final strFromBytes =
              utf8.decode(propertyInfo.value, allowMalformed: true);
          bundle[propertyInfo.name] = await JsonIsolate().decodeJson(strFromBytes);
        }
        return bundle;
      } else {
        throw LocalControlFailed();
      }
    } on InvalidProtocolBufferException catch (e) {
      print(e);
      throw LocalControlFailed();
    }
  }

  Future<Uint8List> _sendRequest(String url, Uint8List data) async {
    final resp = await client.post(
      url,
      headers: {
        'Accept': 'text/plain',
        'Content-type': 'application/x-www-form-urlencoded',
      },
      body: data,
    );

    if (resp.statusCode != 200) {
      throw const LocalControlUnavailable();
    }

    return resp.bodyBytes;
  }
}
