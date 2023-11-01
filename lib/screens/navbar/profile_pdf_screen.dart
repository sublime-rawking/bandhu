import 'dart:io';

import 'package:bandhu/provider/pdf_picker_provider.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
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

  uploadPDF() async {
    selectedPdf = await pickPDFProvider();
    setState(() {});
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
          // Image.asset(
          //   "assets/images/bg.png",
          //   width: size.width,
          //   fit: BoxFit.fill,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: [
              selectedPdf.isEmpty
                  ? InkWell(
                      onTap: uploadPDF, child: emptyPdfPlaceHolder(size: size))
                  : SizedBox(
                      width: size.width,
                      height: size.height - 300,
                      child: selectedPdf.isEmpty
                          ? SfPdfViewer.network(
                              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: selectedPdf.isEmpty
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  elevation: 2,
                  fixedSize: Size(size.width - 40, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Upload PDF',
                  style: fontSemiBold16.copyWith(color: Colors.black),
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
                    onPressed: () {},
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
