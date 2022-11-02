import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/professions.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/authentication_provider.dart';
import 'package:social_pro/ui/home/professional_list_screen/professional_list_for_service.dart';


class ServicesGridView extends StatefulWidget {
  @override
  _ServicesGridViewState createState() => _ServicesGridViewState();
}

class _ServicesGridViewState extends State<ServicesGridView> {
  int rowLength = 0;
  var serviceWidth = 90.w;
  int pageCount = 0;
  int selectedIndex = 0;
  late int lastPageItemLength;
  PageController pageController = PageController();
  int perPageItem = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);

    var num1 = Get.width / serviceWidth;
    rowLength = num1.toInt();
    perPageItem = rowLength + rowLength;
    print("per row Items are $rowLength");
    print("per page Items are $perPageItem");
    var num = (Provider.of<AuthProvider>(context, listen: false)
        .professionList
        .length /
        perPageItem);
    pageCount = num.isInt ? num.toInt() : num.toInt() + 1;

    var reminder = Provider.of<AuthProvider>(context, listen: false)
        .professionList
        .length
        .remainder(perPageItem);
    lastPageItemLength = reminder == 0 ? perPageItem : reminder;

    print("Reminder is $reminder");

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250.h,
            child: PageView.builder(
                controller: pageController,
                itemCount: pageCount,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                itemBuilder: (_, pageIndex) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: List.generate(
                          (pageCount - 1) != pageIndex
                              ? perPageItem
                              : lastPageItemLength, (index) {
                        num t = index + (pageIndex * perPageItem);
                        Professions profession = authProvider
                            .professionList[index + (pageIndex * perPageItem)];
                        return servicesTab(profession, authProvider);
                      }),
                    ),
                  );

                }),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: pageCount,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red
                            .withOpacity(selectedIndex == index ? 1 : 0.5)),
                    margin: EdgeInsets.all(5),
                    width: 40.w,
                    height: 15.h,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  GestureDetector servicesTab(
      Professions profession, AuthProvider authProvider) {
    return GestureDetector(
      onTap: () {
        List<UserData> selectedProfessionals = authProvider.allUser
            .where((element) => element.profession!.id == profession.id)
            .toList();
        print(
            "selected professional length is ${selectedProfessionals.length}");

        Get.to(() => ProfessionalListForService(
            professionals: selectedProfessionals,
            appBarTitle: profession.title));
      },
      child: SizedBox(
        width: serviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.h),
            Container(
              height: 70.h,
              width: serviceWidth,
              margin: EdgeInsets.symmetric(horizontal: serviceWidth / 7),
              decoration: BoxDecoration(
                color: const Color(0xffFDEEED),
                borderRadius: BorderRadius.circular(10.sp),
              ),
              padding: EdgeInsets.all(16.sp),
              child: Image.network(
                profession.image,
                color: AppConfig.colors.themeColor,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "${profession.title}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: latoBold.copyWith(
                  fontSize: 12.sp, color: AppConfig.colors.secondaryThemeColor),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}