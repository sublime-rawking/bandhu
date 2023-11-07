import 'package:bandhu/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatelessWidget {
  final String dcpPDF;
  const PDFScreen({super.key, required this.dcpPDF});

  @override
  Widget build(BuildContext context) {
    onPressBack() => Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: onPressBack,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text('PDF Viewer',
            style: fontSemiBold14.copyWith(color: Colors.black)),
      ),
      body: dcpPDF.isEmpty
          ? SfPdfViewer.network(
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
          : SfPdfViewer.network(
              dcpPDF,
            ),
    );
  }
}
