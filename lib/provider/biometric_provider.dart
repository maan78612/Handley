import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:social_pro/biometric_box/biometric_authentication.dart';


class BiometricProvider extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> onInIt() async {
    bool isAuthenticate=false;
    await checkDeviceSupport().then((supportState) async {
      if (kDebugMode) {
        print("supporting :$supportState");
      }
      if (supportState == SupportState.supported) {
        await checkBiometrics().then((isBiometricAvailable) async {
          if (kDebugMode) {
            print("is Biometric available $isBiometricAvailable");
          }
          if (isBiometricAvailable) {
            await getAvailableBiometrics()
                .then((availableBiometricsList) async {
              if (kDebugMode) {
                print(
                    "available devices are  ${availableBiometricsList.length}");
              }
              if (availableBiometricsList.isNotEmpty) {
                await authenticate().then((isAuthenticated) {
                  if (isAuthenticated) {
                    if (kDebugMode) {
                      print("authenticated");
                    }
                    isAuthenticate=true;
                  } else {
                    if (kDebugMode) {
                      print("Not authenticated");
                    }

                  }
                });
              }else{
                /* If a device does  support biometric but available devices are 0*/
                isAuthenticate=true;
              }
            });
          }
        });
      } else if (supportState == SupportState.unknown) {
        return isAuthenticate;
      } else {
        /* If a device does not support biometric then we simply autologin*/
        isAuthenticate=true;
      }
    });

    notifyListeners();
    return isAuthenticate;
  }

  Future<SupportState> checkDeviceSupport() async {
    SupportState supportState = SupportState.unknown;
    await auth.isDeviceSupported().then((bool isSupported) {
      supportState =
          isSupported ? SupportState.supported : SupportState.unsupported;
    });
    notifyListeners();
    return supportState;
  }

  Future<bool> checkBiometrics() async {
    bool? canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType>? availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      if (kDebugMode) {
        print(e);
      }
      notifyListeners();
    }
    notifyListeners();
    return availableBiometrics;
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
    notifyListeners();
    return authenticated;
  }

  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      notifyListeners();
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      notifyListeners();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }

      return false;
    }
    notifyListeners();
    return authenticated;
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    notifyListeners();
  }
}
