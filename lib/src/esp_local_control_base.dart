import 'dart:async';

import 'package:esp_rainmaker_local_control/src/mDNS_api_manager.dart';
import 'package:meta/meta.dart';
import 'package:multicast_dns/multicast_dns.dart';

/// Entry point for local control.
class LocalControl {
  static const String _serviceType = '_esp_local_ctrl._tcp';

  final MDnsClient _client = MDnsClient();

  /// Rainmaker ID of the device to locally control.
  final String id;

  /// The IP address and port number of the device once
  /// discovered.
  IPAndPort? get deviceAddress {
    return _ipAndPort;
  }

  IPAndPort? _ipAndPort;
  late final Timer _checkingTimer;
  late final Future<void> _clientStart;

  final MDNSApiManager _apiManager = MDNSApiManager();

  /// Creates object for local control and starts polling timer.
  ///
  /// The [scanningPeriod] is how often the service will try to find
  /// the Rainmaker device. If [stopScanOnSuccess] is true, the polling
  /// will stop upon first successfully finding the IP and port.
  LocalControl(this.id,
      [Duration scanningPeriod = const Duration(seconds: 15),
      bool stopScanOnSuccess = true]) {
    _clientStart = _client.start();

    _checkingTimer = Timer.periodic(scanningPeriod, (timer) async {
      final tmpIp = await _getDeviceIP();
      //print(tmpIp);
      if (tmpIp != null) {
        _ipAndPort = tmpIp;

        if (stopScanOnSuccess) {
          timer.cancel();
          _client.stop();
        }
      }

      //print(ipAndPort);
    });
  }

  /// Releases resources used by this object.
  void dispose() {
    _checkingTimer.cancel();
    _client.stop();

    _apiManager.dispose();
  }

  Future<IPAndPort?> _getDeviceIP() async {
    try {
      await _clientStart;

      await for (PtrResourceRecord ptr in _client.lookup<PtrResourceRecord>(
          ResourceRecordQuery.serverPointer(_serviceType))) {
        await for (SrvResourceRecord srv in _client.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(ptr.domainName))) {
          if (id == srv.target.split('.').first) {
            //print('ESP Local found at ${srv.target}:${srv.port} for "${ptr.domainName}".');
            await for (IPAddressResourceRecord ip
                in _client.lookup<IPAddressResourceRecord>(
                    ResourceRecordQuery.addressIPv4(srv.target))) {
              _client.stop();
              //print(ip.address.address);
              return IPAndPort(
                ip: ip.address.address,
                port: srv.port,
              );
            }
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Obtains the node configuration.
  ///
  /// If [forceDeviceCheck] is set to true the function will forcibly poll
  /// for the Rainmaker device regardless of whether it was previously
  /// discovered.
  ///
  /// Throws a `LocalControlUnavailable` exception if the device address
  /// if not known.
  Future<Map<String, dynamic>> getNodeDetails(
      [bool forceDeviceCheck = false]) async {
    if (forceDeviceCheck) {
      final tmpIp = await _getDeviceIP();
      if (tmpIp != null) {
        _ipAndPort = tmpIp;
      }
    }

    if (_ipAndPort == null) {
      throw LocalControlUnavailable();
    }

    return _apiManager.getNodeDetails(_ipAndPort!.baseUrl);
  }

  /// Obtains the device parameters.
  ///
  /// If [forceDeviceCheck] is set to true the function will forcibly poll
  /// for the Rainmaker device regardless of whether it was previously
  /// discovered.
  ///
  /// Throws a `LocalControlUnavailable` exception if the device address
  /// if not known.
  Future<Map<String, dynamic>> getParamsValues(
      [bool forceDeviceCheck = false]) async {
    if (forceDeviceCheck) {
      final tmpIp = await _getDeviceIP();
      if (tmpIp != null) {
        _ipAndPort = tmpIp;
      }
    }

    if (_ipAndPort == null) {
      throw LocalControlUnavailable();
    }

    return _apiManager.getParamsValues(_ipAndPort!.baseUrl);
  }

  /// Sets the device parameters.
  ///
  /// If [forceDeviceCheck] is set to true the function will forcibly poll
  /// for the Rainmaker device regardless of whether it was previously
  /// discovered.
  ///
  /// Throws a `LocalControlUnavailable` exception if the device address
  /// if not known.
  Future<void> updateParamValue(Map<String, dynamic> body,
      [bool forceDeviceCheck = false]) async {
    if (forceDeviceCheck) {
      final tmpIp = await _getDeviceIP();
      if (tmpIp != null) {
        _ipAndPort = tmpIp;
      }
    }

    if (_ipAndPort == null) {
      throw LocalControlUnavailable();
    }

    return _apiManager.updateParamValue(_ipAndPort!.baseUrl, body);
  }
}

@immutable
class IPAndPort {
  /// The IP address of the device.
  final String ip;

  /// The port number of the device.
  final int port;

  IPAndPort({
    required this.ip,
    required this.port,
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
