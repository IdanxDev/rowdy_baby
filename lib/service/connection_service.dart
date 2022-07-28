import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionService {
  Future<bool> checkConnectionState(context, {bool showToast = true}) async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    bool isConnect = getConnectionValue(connectivityResult);
    if (!isConnect && showToast) {
      Get.snackbar('Oops, Something\'s not right', 'message');
    }
    return isConnect;
  }

  bool getConnectionValue(ConnectivityResult connectivityResult) {
    bool status = false;
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        status = true;
        break;
      default:
        status = false;
        break;
    }
    return status;
  }
}
