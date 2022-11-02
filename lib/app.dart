import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/model_classes/App_config_env.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/biometric_provider.dart';
import 'package:social_pro/provider/calender_provider.dart';
import 'package:social_pro/provider/chat_provider.dart';
import 'package:social_pro/env/prod.dart';
import 'package:social_pro/notification_box/fmsg_handler.dart';
import 'package:social_pro/provider/map_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/shared/app_life_cycle.dart';
import 'package:social_pro/ui/splash.dart';



class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ConnectivityServices _con = ConnectivityServices();

  @override
  void initState() {
    AppConfigEnv.fromJson(configPro);
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    /* Checking App Life cycle (resume-pause) and perform function on them*/
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(resumeCallBack: () async {
        print("on Resume");
        Provider.of<AuthProvider>(Get.context!, listen: false)
            .enableLocationFunction();
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => TextFormProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => MapProvider()),
          ChangeNotifierProvider(create: (_) => BiometricProvider()),
          ChangeNotifierProvider(create: (_) => CalenderProvider()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (BuildContext context, Widget? child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Social Pro',
                home: child,
              );
            },
            child: FBMessaging(
              page: SplashScreen(),
              context: context,
            )));
  }
}
