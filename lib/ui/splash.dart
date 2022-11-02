import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/Hive/hive_services.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/firebase_collections.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/on_boarding/on_boarding_screen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;

  Future<void> navigateToNext() async {
    Future.delayed(Duration(seconds: 3), () async {
      await onInit();
      // animation.stop();
    });
  }




  onInit() async {





    /* Fetch current location and professions category list*/
    await Provider.of<AuthProvider>(Get.context!, listen: false)
        .fetchCurrentLatLng();
    await Provider.of<AuthProvider>(Get.context!, listen: false)
        .fetchAllProfessions();

    /* open hive box*/
    await HiveServices.openBox(HiveServices.boxName);

    /* Hive functions to show or hide on boarding screens*/

    String? onBoarding =
        await HiveServices.getString(HiveServices.onBoardingKey);

    if (onBoarding == null) {
      if (kDebugMode) {
        print("first time entering app show on boarding");
      }
      Get.to(() => const OnBoardingScreen());
    } else {
      if (kDebugMode) {
        print("auto login");
      }
      await Provider.of<AuthProvider>(Get.context!, listen: false).autoLogin();
    }
  }

  @override
  void initState() {




    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation.forward();
      }
    });
    animation.forward();

    navigateToNext();
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.colors.whiteColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: Image.asset(
            AppConfig.images.logo,
          ),
        ),
      ),
    );
  }



/* Temporarily  Add Professions Manually */

  Future<void> addProfessionsManually() async {
  await FBCollections.professions.add(Professions(
  id: "1",
  title: "Carpenter",
  createdAt: Timestamp.now(),
  image:
  "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FCarpenter.png?alt=media&token=84d0f626-0302-48a7-b345-9c2f56fc5668",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FCarpenter_Map.png?alt=media&token=80866299-7462-4d9a-bee0-691d4b3dcc19").toJson());
  await   FBCollections.professions.add(Professions(
  id: "2",
  title: "Cleaner",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FCleaner.png?alt=media&token=9c143b85-4ab8-4e2e-bb44-edb720c5736b",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FCleaner_Map.png?alt=media&token=838c8d27-3fd8-483e-b877-3959e854349d").toJson());
  await   FBCollections.professions.add(Professions(
  id: "3",
  title: "Electrician",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FElectrician.png?alt=media&token=1d45ca37-678f-4b6d-81fd-0d037a091738",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FElectrician_Map.png?alt=media&token=57335360-6baf-47fa-8b84-ed8731a2fdd4").toJson());
  await  FBCollections.professions.add(Professions(
  id: "4",
  title: "Repair",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FRepair.png?alt=media&token=89951b2f-3bfc-4977-88fd-cde8e1869b9d",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FRepairs_Map.png?alt=media&token=e7c6f0c5-bda8-47c7-a713-161b06b44fd6").toJson());
  await  FBCollections.professions.add(Professions(
  id: "5",
  title: "Watchman",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FWatchman.png?alt=media&token=231b0017-8654-4d52-bacd-b48335bbd042",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FWatchman_Map.png?alt=media&token=e055f25c-3d34-49fe-bdc7-fe997925932c").toJson());
  await   FBCollections.professions.add(Professions(
  id: "6",
  title: "Laundry",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2Flaundry.png?alt=media&token=1c7afdc7-b343-4d19-9290-a691041d1b28",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FLaundry_Map.png?alt=media&token=bd45c3a5-9269-4230-89da-370423b1589e").toJson());
  await  FBCollections.professions.add(Professions(
  id: "7",
  title: "Painter",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2Fpainter.png?alt=media&token=45f7399f-92e0-4c5f-9260-c611746397a1",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FPainter_Map.png?alt=media&token=7cc52874-b2e5-4590-94df-accd4a76b327").toJson());
  await  FBCollections.professions.add(Professions(
  id: "8",
  title: "Plumber",
  createdAt: Timestamp.now(),
  image: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2FmapIcons%2FPlumber_Map.png?alt=media&token=8de71d33-5ded-4241-89ff-0cebe8040a3b",
  mapIcons: "https://firebasestorage.googleapis.com/v0/b/rhinos-handley.appspot.com/o/Professionas%2Fplumber.png?alt=media&token=682ea6bd-d148-4281-813e-24cd48d72ebb").toJson());
}

}







