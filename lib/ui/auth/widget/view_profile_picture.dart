import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/constants/styles.dart';
import 'package:social_pro/model_classes/user_data.dart';
import 'package:social_pro/utilities/dimension.dart';

class ProfilePreview extends StatelessWidget {
  const ProfilePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Hero(
              tag: 'profile-picture',
              child: ((AppUser.user.imageUrl) != "")
                  ? Container(
                      decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(AppUser.user.imageUrl),
                      ),
                    ))
                  : Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[100],
                        shape: BoxShape.rectangle,
                      ),
                      child: Center(
                          child: Text(
                        "No Image found",
                        textAlign: TextAlign.center,
                        style: latoLight.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: AppConfig.colors.whiteColor),
                      )),
                    )),
        ));
  }
}
