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