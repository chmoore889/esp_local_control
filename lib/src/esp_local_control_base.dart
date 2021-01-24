import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:multicast_dns/multicast_dns.dart';

class LocalControl {
  static const String serviceType = '_esp_local_ctrl._tcp';

  static const String path = '/esp_local_ctrl/control';

  final MDnsClient client = MDnsClient(
    rawDatagramSocketFactory: (dynamic host, int port, {bool reuseAddress, bool reusePort, int ttl}) {
      return RawDatagramSocket.bind(host, port, reuseAddress: true, reusePort: false, ttl: ttl);
    },
  );

  String id;
  IPAndPort ipAndPort;

  Timer _checkingTimer;

  LocalControl(this.id) : assert(id != null) {
    _checkingTimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      ipAndPort = await _getDeviceIP();
    });
  }

  void dispose() {
    _checkingTimer?.cancel();
  }

  Future<IPAndPort> _getDeviceIP() async {
    await client.start();

    await for(PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(serviceType))) {
      await for(SrvResourceRecord srv in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
        if(id == srv.target.split('.').first) {
          //print('ESP Local found at ${srv.target}:${srv.port} for "${ptr.domainName}".');
          await for(IPAddressResourceRecord ip in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
            client.stop();
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

  Future<void> makeRequest() async {
    if(ipAndPort == null) {
      throw const LocalControlUnavailable();
    }

    final resp = await post(
      ipAndPort.baseUrl + path,
      headers: {
        'Accept': 'text/plain',
        'Content-type': 'application/x-www-form-urlencoded',
      },
    );

    if(resp.statusCode != 200) {
      throw const LocalControlUnavailable();
    }

    
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
