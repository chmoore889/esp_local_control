import 'dart:async';
import 'dart:io';

import 'package:esp_local_control/src/mDNS_api_manager.dart';
import 'package:meta/meta.dart';
import 'package:multicast_dns/multicast_dns.dart';

class LocalControl {
  static const String serviceType = '_esp_local_ctrl._tcp';

  final MDnsClient client = MDnsClient(
    rawDatagramSocketFactory: (dynamic host, int port,
        {bool reuseAddress, bool reusePort, int ttl}) {
      return RawDatagramSocket.bind(host, port,
          reuseAddress: true, reusePort: false, ttl: ttl);
    },
  );

  String id;
  IPAndPort ipAndPort;

  Timer _checkingTimer;

  final MDNSApiManager _apiManager = MDNSApiManager();

  LocalControl(this.id) : assert(id != null) {
    _checkingTimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      final tmpIp = await _getDeviceIP();
      if(tmpIp != null) {
        ipAndPort = tmpIp;
      }
      
      //print(ipAndPort);
    });
  }

  void dispose() {
    _checkingTimer?.cancel();
    _apiManager.dispose();
  }

  Future<IPAndPort> _getDeviceIP() async {
    await client.start();

    await for (PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceType))) {
      await for (SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName))) {
        if (id == srv.target.split('.').first) {
          //print('ESP Local found at ${srv.target}:${srv.port} for "${ptr.domainName}".');
          await for (IPAddressResourceRecord ip
              in client.lookup<IPAddressResourceRecord>(
                  ResourceRecordQuery.addressIPv4(srv.target))) {
            client.stop();
            //print(ip.address.address);
            return IPAndPort(
              ip: ip.address.address,
              port: srv.port,
            );
          }
        }
      }
    }

    client.stop();
    return null;
  }

  Future<Map<String, dynamic>> getNodeDetails([bool forceDeviceCheck = false]) async {
    if(forceDeviceCheck) {
      ipAndPort = await _getDeviceIP();
    }

    if(ipAndPort == null) {
      throw LocalControlUnavailable();
    }

    return _apiManager.getNodeDetails(ipAndPort.baseUrl);
  }

  Future<Map<String, dynamic>> getParamsValues([bool forceDeviceCheck = false]) async {
    if(forceDeviceCheck) {
      ipAndPort = await _getDeviceIP();
    }

    if(ipAndPort == null) {
      throw LocalControlUnavailable();
    }

    return _apiManager.getParamsValues(ipAndPort.baseUrl);
  }

  Future<void> updateParamValue(Map<String, dynamic> body, [bool forceDeviceCheck = false]) async {
    if(forceDeviceCheck) {
      ipAndPort = await _getDeviceIP();
    }
    
    if(ipAndPort == null) {
      throw LocalControlUnavailable();
    }

    return _apiManager.updateParamValue(ipAndPort.baseUrl, body);
  }
}

@immutable
class IPAndPort {
  final String ip;
  final int port;

  IPAndPort({
    @required this.ip,
    @required this.port,
  });

  String get baseUrl {
    return 'http://$ip:$port';
  }

  @override
  String toString() {
    return 'IPAndPort{IP: $ip, Port: $port}';
  }
}

abstract class LocalControlException implements Exception {
  final String frontFacingText;

  const LocalControlException(this.frontFacingText);

  @override
  String toString();
}

class LocalControlUnavailable extends LocalControlException {
  const LocalControlUnavailable() : super('No local device found');

  @override
  String toString() => 'LocalControlUnavailable: ${super.frontFacingText}';
}

class LocalControlFailed extends LocalControlException {
  const LocalControlFailed() : super('There was a problem with local control');

  @override
  String toString() => 'LocalControlFailed: ${super.frontFacingText}';
}
