import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/booking_model.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/Map/Maps.dart';
import 'package:social_pro/ui/home/available_professionals/available_professionals.dart';
import 'package:social_pro/ui/home/professional_list_screen/professional_list_for_service.dart';
import 'package:social_pro/ui/home/professional_list_screen/professional_list_home_page.dart';
import 'package:social_pro/ui/home/widgets/enable_location_dialog.dart';
import 'package:social_pro/ui/home/widgets/professional_dialog_card.dart';
import 'package:social_pro/ui/home/widgets/search_bar.dart';
import 'package:social_pro/ui/home/widgets/service_grid.dart';
import 'package:social_pro/ui/home/widgets/user_card_shimmer.dart';
import 'package:social_pro/ui/shared/custom_loader.dart';
import 'package:social_pro/ui/shared/empty_screen.dart';
import 'package:social_pro/ui/shared/location_btn.dart';
import 'package:social_pro/utilities/enums.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchCtrl = TextEditingController();
  String toSearch = "";
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, AuthProvider, TextFormProvider>(
        builder: (context, appProvider, authProvider, textFormProvider, _) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading || authProvider.isLoading,
        progressIndicator: customLoader(),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppConfig.colors.whiteColor,
            body: AppUser.user.userType == UserType.customer
                ? customerHomeScreen(
                    authProvider, appProvider, textFormProvider)
                : professionalHomeScreen(authProvider, appProvider),
          ),
        ),
      );
    });
  }

  Widget professionalHomeScreen(
      AuthProvider authProvider, AppProvider appProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              activeServices(appProvider, authProvider),
              statisticsAndAnalytics(appProvider, authProvider),
              SizedBox(height: 15.h),
            ]),
      ),
    );
  }

  Column statisticsAndAnalytics(
      AppProvider appProvider, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Statistics & Analysis",
          style: latoBlack.copyWith(
              fontSize: 16.sp, color: AppConfig.colors.secondaryThemeColor),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(8.sp),
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: Color(0xffF5F4F4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              border: Border.all(
                                  color: AppConfig.colors.themeColor)),
                          child: Text(
                            "${AppUser.user.numberOfJobs}",
                            style: latoBold.copyWith(
                                fontSize: 21,
                                color: AppConfig.colors.themeColor),
                          )),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          "Jobs Completed",
                          style: latoBold.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.themeColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(8.sp),
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: Color(0xffF5F4F4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              border: Border.all(
                                  color: AppConfig.colors.themeColor)),
                          child: Text(
                            "${AppUser.user.ratingCount}",
                            style: latoBold.copyWith(
                                fontSize: 21,
                                color: AppConfig.colors.themeColor),
                          )),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          "Total Ratings",
                          style: latoBold.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.themeColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
        Container(
            padding: EdgeInsets.all(8.sp),
            margin: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: Color(0xffF5F4F4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            border:
                                Border.all(color: AppConfig.colors.themeColor)),
                        child: Text(
                          "${AppUser.user.rating!.toStringAsFixed(1)}",
                          style: latoBold.copyWith(
                              fontSize: 21, color: AppConfig.colors.themeColor),
                        )),
                    SizedBox(width: 5.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Ratings",
                          style: latoBold.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.themeColor),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.sp),
                          child: Text(
                            " out of 5",
                            style: latoRegular.copyWith(
                                fontSize: 12.sp,
                                color: AppConfig.colors.secondaryThemeColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(
                        "Feedback",
                        style: latoBold.copyWith(
                            fontSize: 12.sp,
                            color: AppConfig.colors.secondaryThemeColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(child: Divider())
                  ],
                ),
                SizedBox(
                  height: 180.h,
                  child: appProvider.ratedBookingsOfProfessional.isEmpty
                      ? Center(
                          child: EmptyScreen(
                              image: AppConfig.images.chat,
                              message: "No Feedback given!",
                              isAddAppBarSize: false),
                        )
                      : ListView(
                          children: List.generate(
                              (appProvider.ratedBookingsOfProfessional.length >=
                                      3)
                                  ? 3
                                  : appProvider.ratedBookingsOfProfessional
                                      .length, (index) {
                          BookingModel reviewData =
                              appProvider.ratedBookingsOfProfessional[index];
                          reviewData.userData = authProvider.allUser.firstWhere(
                              (element) =>
                                  element.email == reviewData.customerId);
                          return Container(
                            padding: EdgeInsets.all(8.sp),
                            margin: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: AppConfig.colors.whiteColor,
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(4.sp),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                        border: Border.all(
                                            color:
                                                AppConfig.colors.themeColor)),
                                    child: (reviewData.userData?.imageUrl ??
                                                "") !=
                                            ""
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                reviewData.userData!.imageUrl,
                                            fit: BoxFit.cover,
                                            width: 45.w,
                                            height: 45.h,
                                          )
                                        : Padding(
                                            padding: EdgeInsets.all(5.sp),
                                            child: Image.asset(
                                              AppConfig.images.account,
                                              color:
                                                  AppConfig.colors.themeColor,
                                              fit: BoxFit.contain,
                                              width: 35.w,
                                              height: 35.h,
                                            ),
                                          )),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${reviewData.userData!.firstName} ${reviewData.userData!.lastName}",
                                        style: latoBold.copyWith(
                                            fontSize: 14.sp,
                                            color: AppConfig
                                                .colors.secondaryThemeColor),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                          "${DateFormat('hh:mm a').format(reviewData.bookingDate!.toDate())} - ${DateFormat.yMd().format(reviewData.bookingDate!.toDate())}",
                                          style: latoBold.copyWith(
                                              fontSize: 10.sp,
                                              color: AppConfig
                                                  .colors.secondaryThemeColor)),
                                      Text(reviewData.rating?.review ?? "",
                                          style: latoRegular.copyWith(
                                              fontSize: 10.sp,
                                              color: AppConfig
                                                  .colors.secondaryThemeColor)),
                                      SizedBox(height: 5.h),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${reviewData.rating!.rating!.toStringAsFixed(2)} ",
                                        style:
                                            latoBold.copyWith(fontSize: 10.sp)),
                                    Icon(
                                      Icons.star,
                                      size: 10.sp,
                                      color: Color(0xffE6C65C),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        })),
                )
              ],
            )),
      ],
    );
  }

  Widget activeServices(AppProvider appProvider, AuthProvider authProvider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Active Services",
                style: latoBlack.copyWith(
                    fontSize: 16.sp,
                    color: AppConfig.colors.secondaryThemeColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                appProvider.onDashboardTab(1);
                appProvider.bookingTabStatusChanger(2);
              },
              child: Text(
                "View All",
                style: latoBold.copyWith(
                    fontSize: 12.sp, color: AppConfig.colors.themeColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (appProvider.userActiveBookings.isNotEmpty)
          Column(
            children: List.generate(
                appProvider.userActiveBookings.length >= 3
                    ? 3
                    : appProvider.userActiveBookings.length == 2
                        ? 2
                        : appProvider.userActiveBookings.length == 1
                            ? 1
                            : appProvider.userActiveBookings.length, (index) {
              BookingModel bookings = appProvider.userActiveBookings[index];
              bookings.userData = authProvider.allUser.firstWhere(
                  (element) => element.email == bookings.customerId);
              return Container(
                  padding: EdgeInsets.all(8.sp),
                  margin: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: Color(0xffFDEEED),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(4.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              border: Border.all(
                                  color: AppConfig.colors.themeColor)),
                          child: (bookings.userData?.imageUrl ?? "") != ""
                              ? CachedNetworkImage(
                                  imageUrl: bookings.userData!.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 45.w,
                                  height: 45.h,
                                )
                              : Padding(
                                  padding: EdgeInsets.all(5.sp),
                                  child: Image.asset(
                                    AppConfig.images.account,
                                    color: AppConfig.colors.themeColor,
                                    fit: BoxFit.contain,
                                    width: 35.w,
                                    height: 35.h,
                                  ),
                                )),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${bookings.userData!.firstName} ${bookings.userData!.lastName}",
                              style: latoBold.copyWith(
                                  fontSize: 14.sp,
                                  color: AppConfig.colors.secondaryThemeColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                                "${DateFormat('hh:mm a').format(bookings.bookingDate!.toDate())} - ${DateFormat.yMd().format(bookings.bookingDate!.toDate())}",
                                style: latoRegular.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor)),
                            Text(bookings.bookingAddress.address,
                                style: latoRegular.copyWith(
                                    fontSize: 10.sp,
                                    color:
                                        AppConfig.colors.secondaryThemeColor)),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      locationBtn(
                          bookings, AppConfig.colors.themeColor, Colors.white),
                    ],
                  ));
            }),
          )
        else
          Padding(
            padding: EdgeInsets.all(12.0.sp),
            child: EmptyScreen(
                image: AppConfig.images.bookings,
                message: "No Active Services",
                isAddAppBarSize: false),
          ),
      ],
    );
  }

  Widget customerHomeScreen(AuthProvider authProvider, AppProvider appProvider,
      TextFormProvider textFormProvider) {
    double imageSize = 25.w;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (AppUser.user.location != null) currentLocationTitle(),
            SizedBox(height: 15.h),
            SearchBar(),
            if (textFormProvider.searchField.isNotEmpty)
              Expanded(
                  child: ProfessionalListHomePage(
                professionals: authProvider.allUser,
                title: 'Search',
              ))
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.sp),
                      checkAvailableProfessionals(authProvider),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.0.sp, horizontal: 10.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Services",
                              style: latoBlack.copyWith(
                                  fontSize: 18.sp,
                                  color: AppConfig.colors.secondaryThemeColor),
                            ),
                          ],
                        ),
                      ),
                      ServicesGridView(),
                      SizedBox(height: 30.h),
                      authProvider.allUser.isNotEmpty
                          ? recommendedPro(authProvider, imageSize)
                          : SizedBox(),
                      SizedBox(height: 20.h),
                      nearByPro(authProvider, imageSize),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              )
          ]),
    );
  }

  Widget checkAvailableProfessionals(AuthProvider authProvider) {
    return GestureDetector(
      onTap: () {
        /* Clearing filters and initializing list with all professionals*/
        authProvider.applyFilterInitially();
        authProvider.selectDateForFilter(DateTime.now());
        Get.to(AvailableProfessionals());
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 6.0.sp, horizontal: 10.sp),
          padding: EdgeInsets.symmetric(vertical: 12.0.sp, horizontal: 10.sp),
          decoration: BoxDecoration(
            color: const Color(0xffFDEEED),
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppConfig.images.availableIcon,
                      height: 22.sp, width: 22.sp),
                  SizedBox(width: 15.sp),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Looking for a professional now or a specific date?",
                          style: latoRegular.copyWith(
                              fontSize: 12.sp,
                              color: AppConfig.colors.secondaryThemeColor)),
                      SizedBox(height: 2.sp),
                      Text("Check available professionals",
                          style: latoBold.copyWith(
                              fontSize: 14.sp,
                              color: AppConfig.colors.themeColor))
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }

  Row currentLocationTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppConfig.images.location, width: 15.sp, height: 15.sp),
        SizedBox(width: 10.h),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Location",
                style: latoBold.copyWith(
                  fontSize: 10.sp,
                  color: AppConfig.colors.secondaryThemeColor,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: DottedDecoration(
                      color: AppConfig.colors.secondaryThemeColor),
                  child: Text(
                    AppUser.user.address,
                    style: latoBold.copyWith(
                      fontSize: 14.sp,
                      color: AppConfig.colors.secondaryThemeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget recommendedPro(AuthProvider authProvider, double imageSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recommended Professionals",
                style: latoBlack.copyWith(
                  fontSize: 16.sp,
                  color: AppConfig.colors.secondaryThemeColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ProfessionalListForService(
                    professionals: authProvider.allUser,
                    appBarTitle: 'Recommended Professionals',
                  ));
                },
                child: Text(
                  "View All",
                  style: latoBold.copyWith(
                    fontSize: 12.sp,
                    color: AppConfig.colors.themeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          professionalCard(authProvider, imageSize, authProvider.allUser),
        ],
      ),
    );
  }

  Widget nearByPro(AuthProvider authProvider, double imageSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nearby Professionals",
                style: latoBlack.copyWith(
                  fontSize: 16.sp,
                  color: AppConfig.colors.secondaryThemeColor,
                ),
              ),
              /* if location is enabled and list of nearBy professionals are not empty*/
              if (AppUser.user.location != null)
                InkWell(
                  onTap: () async {
                    Get.to(ViewNearbyProMap());
                  },
                  child: Text(
                    "View Map",
                    style: latoBold.copyWith(
                      fontSize: 12.sp,
                      color: AppConfig.colors.themeColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),
          /* if there is data and location is enabled as well*/
          if (authProvider.professionalNearByUsers.isNotEmpty &&
              AppUser.user.location != null)
            professionalCard(
                authProvider, imageSize, authProvider.professionalNearByUsers),
          /* if location is disabled*/
          if (authProvider.appUserData?.location == null)
            Stack(
              alignment: Alignment.center,
              children: [
                UserCardShimmer(),
                Column(
                  children: [
                    Text(
                      "To enhance your experience and show you nearby professionals",
                      style: latoBold.copyWith(
                        fontSize: 10.sp,
                        color: AppConfig.colors.secondaryThemeColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    InkWell(
                      onTap: () async {
                        await enableLocationDialog();
                      },
                      child: Text(
                        "Enable Location Services",
                        style: latoBold.copyWith(
                          fontSize: 12.sp,
                          color: AppConfig.colors.themeColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          /* if location is enabled but there are no nearBy professionals*/
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget professionalCard(AuthProvider authProvider, double imageSize,
      List<UserData> professionalList) {
    return Row(
      children: List.generate(professionalList.length >= 2 ? 2 : 1, (index) {
        UserData proData = professionalList[index];
        return Expanded(
          child: Row(
            children: [
              if (professionalList.length == 1) Spacer(flex: 1),
              Expanded(
                  flex: 3,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.dialog(ProfessionalDialogCard(
                            professionalUser: proData,
                          ));
                        },
                        child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin:
                                EdgeInsets.symmetric(horizontal: imageSize / 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                border:
                                    Border.all(color: const Color(0xffD9D4D5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: imageSize / 1.3),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${proData.firstName} ${proData.lastName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: latoBold.copyWith(
                                          fontSize: 12.sp,
                                          color: AppConfig
                                              .colors.secondaryThemeColor,
                                        ),
                                      ),
                                      Text(
                                        proData.profession!.title,
                                        style: latoBold.copyWith(
                                          fontSize: 10.sp,
                                          color: AppConfig
                                              .colors.secondaryThemeColor,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${proData.rating?.toStringAsFixed(1)}",
                                            style: latoBold.copyWith(
                                                fontSize: 10.sp,
                                                color: AppConfig.colors
                                                    .secondaryThemeColor),
                                          ),
                                          SizedBox(width: 5.w),
                                          Icon(Icons.star,
                                              color: Colors.yellow,
                                              size: 16.sp),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.info_outline,
                                  color: Color(0xff3A3335),
                                  size: 16.sp,
                                )
                              ],
                            )),
                      ),
                      Container(
                          padding: EdgeInsets.all(4.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppConfig.colors.themeColor)),
                          child: proData.imageUrl != ""
                              ? CachedNetworkImage(
                                  imageUrl: proData.imageUrl,
                                  fit: BoxFit.contain,
                                  width: imageSize,
                                  height: 40.h,
                                )
                              : Image.asset(
                                  AppConfig.images.account,
                                  color: AppConfig.colors.themeColor,
                                  fit: BoxFit.contain,
                                  width: imageSize,
                                  height: 30.h,
                                )),
                    ],
                  )),
              if (professionalList.length == 1) Spacer(flex: 1),
            ],
          ),
        );
      }),
    );
  }
}
