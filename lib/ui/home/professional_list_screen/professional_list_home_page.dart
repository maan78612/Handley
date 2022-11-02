import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/provider/app_provider.dart';
import 'package:social_pro/provider/text_form_provider.dart';
import 'package:social_pro/ui/shared/professional_list.dart';

import '../widgets/search_bar.dart';


class ProfessionalListHomePage extends StatelessWidget {
  List<UserData> professionals;
  String title;

  ProfessionalListHomePage({Key? key,required this.professionals,required this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, TextFormProvider>(
        builder: (context, appProvider, textFormProvider, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [

                    Padding(
                      padding:
                      EdgeInsets.only(top: 20.0.h, left: 8.0.w, bottom: 8.h),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: latoBlack.copyWith(
                          fontSize: 16.sp,
                          color: AppConfig.colors.secondaryThemeColor,
                        ),
                      ),
                    ),
                    ProfessionalsList(professionals: professionals,),
                  ]),
            ),
          );
        });
  }
}

