
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/provider/biometric_provider.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({Key? key}) : super(key: key);

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication> {
  BiometricProvider biometricProvider =
      Provider.of(Get.context!, listen: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await biometricProvider.onInIt();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BiometricProvider>(
        builder: (context, biometricProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await biometricProvider.onInIt();
              },
              child: const Center(child: Text('Check authentication')),
            ),
          ),
        ),
      );
    });
  }
}

enum SupportState {
  unknown,
  supported,
  unsupported,
}
