import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/home/widgets/search_bar.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/professional_list.dart';



class ProfessionalListForService extends StatefulWidget {
  List<UserData> professionals;
  String appBarTitle;

  ProfessionalListForService(
      {Key? key, required this.professionals, required this.appBarTitle})
      : super(key: key);

  @override
  State<ProfessionalListForService> createState() =>
      _ProfessionalListForServiceState();
}

class _ProfessionalListForServiceState
    extends State<ProfessionalListForService> {
  List<UserData> filterProfessionals = [];

  List<bool> clear = [false, false, false];

  @override
  void initState() {
    filterProfessionals = widget.professionals;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, TextFormProvider>(
        builder: (context, appProvider, textFormProvider, _) {
      return Scaffold(
        appBar: customAppBar(
            onTab: () {
              textFormProvider.clearSearchText();
              Get.back();
            },
            title: widget.appBarTitle),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SearchBar(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      headerBtn(
                          onTab: () {
                            clear[0] = true;
                            clear[1] = false;
                            clear[2] = false;
                            filterProfessionals = appProvider
                                .newlyAddedProfessional(widget.professionals);
                            print("${filterProfessionals.length}");
                          },
                          image: AppConfig.images.newly_added,
                          title: 'Newly\nAdded',
                          index: 0),
                      headerBtn(
                          onTab: () {
                            clear[0] = false;
                            clear[1] = true;
                            clear[2] = false;
                            filterProfessionals = appProvider
                                .topRatedProfessional(widget.professionals);
                          },
                          image: AppConfig.images.newly_added,
                          title: 'Top\nRated',
                          index: 1),
                      headerBtn(
                          onTab: () {
                            clear[0] = false;
                            clear[1] = false;
                            clear[2] = true;
                            filterProfessionals =
                                appProvider.highlyExperiencedProfessional(
                                    widget.professionals);
                          },
                          image: AppConfig.images.highly_experienced,
                          title: 'Highly\nExperienced',
                          index: 2),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 20.0.h, left: 8.0.w, bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All ${widget.appBarTitle}s",
                        textAlign: TextAlign.center,
                        style: latoBlack.copyWith(
                          fontSize: 16.sp,
                          color: AppConfig.colors.secondaryThemeColor,
                        ),
                      ),
                      if (clear.contains(true))
                        InkWell(
                          onTap: () {
                            setState(() {
                              filterProfessionals = widget.professionals;
                              clear[0] = false;
                              clear[1] = false;
                              clear[2] = false;
                            });
                          },
                          child: Text(
                            "clear",
                            textAlign: TextAlign.center,
                            style: latoBold.copyWith(
                              fontSize: 16.sp,
                              color: AppConfig.colors.themeColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProfessionalsList(professionals: filterProfessionals),
                      SizedBox(height: 20.h),
                    ],
                  ),
                )),
              ]),
        ),
      );
    });
  }

  Widget headerBtn(
      {required String image,
      required Function onTab,
      required String title,
      required int index}) {
    return GestureDetector(
      onTap: () {
        onTab();
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 60.h,
                width: 60.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFDEEED),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16.sp),
                child: Image.asset(
                  image,
                  color: AppConfig.colors.themeColor,
                ),
              ),
              if (clear[index])
                Container(
                  width: 10.h,
                  height: 10.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConfig.colors.themeColor,
                  ),
                )
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: latoBold.copyWith(
              fontSize: 12.sp,
              color: AppConfig.colors.secondaryThemeColor,
            ),
          )
        ],
      ),
    );
  }
}
