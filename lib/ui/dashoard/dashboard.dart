import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/UI/Bookings/bookings.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/auth/widget/auth_appBar.dart';
import 'package:social_pro/ui/home/home_screen.dart';
import 'package:social_pro/ui/more/more_screen.dart';
import 'package:social_pro/ui/shared/custom_floating_action_Btn.dart';

class DashBoard extends StatefulWidget {
  int index;

  DashBoard({Key? key, required this.index}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState(index: index);
}

class _DashBoardState extends State<DashBoard> {
  int index;

  _DashBoardState({required this.index});

  var scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AppProvider>(Get.context!, listen: false)
          .onDashboardTab(index);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, AppProvider>(
        builder: (context, auth, appProvider, _) {
      return Scaffold(
        key: scaffoldKey1,
        backgroundColor: AppConfig.colors.whiteColor,
        appBar: dashboardAppBar(appProvider),
        body: _getPage(appProvider.selectedDashBoardIndex, auth),
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: bottomNavigationIcon(
                      appProvider, 0, AppConfig.images.home),
                  label: 'Home',
                  backgroundColor: const Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                  icon: bottomNavigationIcon(
                      appProvider, 1, AppConfig.images.bookings),
                  label: 'Bookings',
                  backgroundColor: const Color(0xffF4F2F2)),
              BottomNavigationBarItem(
                  icon: bottomNavigationIcon(
                      appProvider, 2, AppConfig.images.moreIcon),
                  label: 'More',
                  backgroundColor: const Color(0xffF4F2F2)),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: appProvider.selectedDashBoardIndex,
            showUnselectedLabels: true,
            selectedItemColor: AppConfig.colors.themeColor,
            unselectedItemColor: Color(0xffD9D4D5),
            selectedIconTheme: const IconThemeData(color: Colors.black),
            unselectedLabelStyle:
                latoBold.copyWith(fontSize: 12.sp, height: 2.h),
            selectedLabelStyle: latoBold.copyWith(fontSize: 12.sp),
            onTap: appProvider.onDashboardTab,
            elevation: 5),
        floatingActionButton:
            CustomFloatingActionBtn.customFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }

  ImageIcon bottomNavigationIcon(
      AppProvider appProvider, int index, String image) {
    return ImageIcon(
      AssetImage(image),
      size: 25.sp,
      color: appProvider.selectedDashBoardIndex == index
          ? AppConfig.colors.themeColor
          : Color(0xffD9D4D5),
    );
  }

  _getPage(int page, AuthProvider authProvider) {
    switch (page) {
      case 0:
        return HomeScreen();
      case 1:
        return Bookings();

      case 2:
        return More();

      default:
        return HomeScreen();
    }
  }
}
