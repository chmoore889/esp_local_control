## Introduction
This is a library for controlling ESP Rainmaker devices over a local network rather than through the Rainmaker servers. It gives access to overall node configuration as well as the state of each device.

It uses the [multicast_dns](https://pub.dev/packages/multicast_dns/versions/0.2.2) package for device discovery. This service does not consistently discover Rainmaker devices on local networks, so a timer is used to regularly poll for the device IP and port information. The period of this timer can be set when contructing the `LocalControl` object, though it has a default value of 15 seconds.

## Usage

A simple usage example:

```dart
import 'package:esp_rainmaker_local_control/src/esp_local_control_base.dart';

Future<void> main() async {
  final control = LocalControl('rainmaker device id');
  Map<String,dynamic> nodeValues;
  try{
    nodeValues = await control.getParamsValues();
    await control.updateParamValue({
      'device': {
        'deivce state': true,
      }
    });
  } catch(e) {
    print(e);

    //Handle local control failure
    //Use Rainmaker API as a backup
  }

  print(nodeValues);
  control.dispose();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/chmoore889/esp_local_control/issues
