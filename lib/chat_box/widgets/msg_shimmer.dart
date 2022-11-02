import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MsgShimmer extends StatelessWidget {
  const MsgShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => const MsgShimmerWidget(),
      itemCount: 20,
    );
  }
}

class MsgShimmerWidget extends StatelessWidget {
  const MsgShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: msg(),
      enabled: true,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
    );
  }

  msg() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        height: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: Get.width * 0.2,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Get.width * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.06,
                  ),
                  Expanded(
                    child: Container(
                      width: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      height: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
