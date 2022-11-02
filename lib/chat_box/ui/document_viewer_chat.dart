import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/ui/shared/custom_app_bar.dart';
import 'package:social_pro/ui/shared/web_view_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class DocumentViewerChat extends StatelessWidget {
  String doc;
  bool isPDF;

  DocumentViewerChat({Key? key, required this.doc, required this.isPDF})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.colors.whiteColor,
      appBar:  customAppBar(onTab: () => Get.back(), title: isPDF?"PDF View":"File View"),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isPDF
              ? SfPdfViewer.network(
                  doc,
                  scrollDirection: PdfScrollDirection.vertical,
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    AlertDialog(
                      title: Text(details.error),
                      content: Text(details.description),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                )
              : WebViewCustom(url: doc)),
    );
  }
}
