import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_pro/constants/app_constants.dart';
import 'package:social_pro/ui/auth/widget/auth_appBar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class DocumentViewerSignUp extends StatelessWidget {
  File doc;
  bool isPDF;

  DocumentViewerSignUp({Key? key, required this.doc, required this.isPDF})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.colors.whiteColor,
      appBar: authAppBar(onTab: () {
        Get.back();
      }),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isPDF
              ? SfPdfViewer.file(
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
              : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: FileImage(doc),
                ),
              ))),
    );
  }
}