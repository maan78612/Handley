import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_pro/notification_box/fmsg_handler.dart';
import 'app.dart';


main({String env = "dev"}) async {
  if (kDebugMode) print("--- We are on mode : $env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /* For firebase back-ground messaging*/
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  runApp(MyApp());
}
