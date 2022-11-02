import 'package:flutter/material.dart';
import 'package:social_pro/utilities/dimension.dart';
import 'package:social_pro/constants/styles.dart';

class EmptyHomeScreenCustomer extends StatelessWidget {
  const EmptyHomeScreenCustomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sorry! No professional Available at this moment",
          textAlign: TextAlign.center,
          style: latoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
        )
      ],
    ));
  }
}
class EmptyHomeScreenProfessional extends StatelessWidget {
  const EmptyHomeScreenProfessional({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sorry! No Previous record found",
          textAlign: TextAlign.center,
          style: latoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
        )
      ],
    ));
  }
}
