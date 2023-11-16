// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/provider/pdf_picker_provider.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfProfileScreen extends ConsumerStatefulWidget {
  const PdfProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PdfProfileScreenState();
}

class _PdfProfileScreenState extends ConsumerState<PdfProfileScreen> {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  String selectedPdf = "";
  @override
  void initState() {
    selectedPdf.isEmpty ? null : super.initState();
  }

  pickPDF() async {
    selectedPdf = await pickPDFProvider();
    setState(() {});
  }

  uploadPDF() async {
    var res = await Auth().uploadPDF(filePath: selectedPdf, ref: ref);
    if (res) {
      await Auth().getUserData(ref: ref, context: context);
      write(ref.read(userDataProvider).toString());
    }
    setState(() => selectedPdf = "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile PDF",
          style: fontSemiBold14.copyWith(color: black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: [
              selectedPdf.isEmpty && ref.read(userDataProvider).dcp.isEmpty
                  ? InkWell(
                      onTap: pickPDF, child: emptyPdfPlaceHolder(size: size))
                  : SizedBox(
                      width: size.width,
                      height: size.height - 300,
                      child: selectedPdf.isEmpty
                          ? SfPdfViewer.network(
                              "$baseUrl/uploads/dcp/${ref.read(userDataProvider).dcp}")
                          : SfPdfViewer.file(
                              File(selectedPdf),
                            ),
                    ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: selectedPdf.isEmpty
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ref.read(userDataProvider).dcp.isEmpty
                      ? Colors.grey.shade400
                      : colorPrimary,
                  elevation: 2,
                  fixedSize: Size(size.width - 40, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: pickPDF,
                child: Text(
                  ref.read(userDataProvider).dcp.isEmpty
                      ? 'Select PDF'
                      : 'Select new PDF',
                  style: fontSemiBold16.copyWith(color: Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      elevation: 2,
                      fixedSize: Size(size.width / 2.4, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: uploadPDF,
                    child: Text(
                      'Upload PDF',
                      style: fontSemiBold16.copyWith(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorAccentLight,
                      elevation: 2,
                      fixedSize: Size(size.width / 2.4, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => setState(() => selectedPdf = ""),
                    child: Text(
                      'Remove PDF',
                      style: fontSemiBold16.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget emptyPdfPlaceHolder({required Size size}) => Container(
      height: size.height - 300,
      width: size.width,
      decoration: BoxDecoration(
          color: Colors
              .grey.shade300, // Replace with your desired background color
          borderRadius: BorderRadius.circular(12)),
      // margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          'No PDF Selected',
          style: fontSemiBold16.copyWith(color: Colors.black),
        ),
      ),
    );
