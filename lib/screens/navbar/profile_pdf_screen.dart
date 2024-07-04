// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/provider/auth_services.dart';
import 'package:bandhu/provider/pdf_picker_provider.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

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
  final StateProvider<double> uploadProgress =
      StateProvider<double>((ref) => 0.0);
  final StateProvider<bool> isUploading = StateProvider<bool>((ref) => false);
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
    ref.watch(isUploading.notifier).state = true;
    var res = await Auth.instance.uploadPDF(
        filePath: selectedPdf,
        ref: ref,
        sendProgress: (sent, total) {
          ref.watch(uploadProgress.notifier).state = sent / total;
        },
        context: context);
    if (res) {
      print(ref.read(AuthServices.instance.userDataProvider).toJson());
      write(ref.read(AuthServices.instance.userDataProvider).toString());
    }
    ref.watch(isUploading.notifier).state = false;
    setState(() => selectedPdf = "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(ref.read(AuthServices.instance.userDataProvider).dcp);
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(children: [
              selectedPdf.isEmpty &&
                      (ref.read(AuthServices.instance.userDataProvider).dcp ==
                              null ||
                          ref
                              .read(AuthServices.instance.userDataProvider)
                              .dcp!
                              .isEmpty)
                  ? InkWell(
                      onTap: pickPDF, child: emptyPdfPlaceHolder(size: size))
                  : Stack(
                      children: [
                        ref.watch(isUploading)
                            ? Positioned.fill(
                            child: WaterEffect(
                              progress: ref.watch(uploadProgress),
                            ))
                            : SizedBox(),
                        ref.watch(isUploading)
                            ? SizedBox(
                                width: size.width,
                                height: size.height - 350,
                                child: Center(
                                  child: Text(
                                    "${(ref.watch(uploadProgress) * 100)
                                            .toStringAsFixed(0)}%",
                                    style: fontSemiBold20.copyWith(
                                        color: Colors.black45),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: size.width,
                                height: size.height - 350,
                                child: selectedPdf.isEmpty
                                    ? SfPdfViewer.network(
                                        "$siteUrl/dcp/${ref.read(AuthServices.instance.userDataProvider).dcp}")
                                    : SfPdfViewer.file(
                                        File(selectedPdf),
                                      ),
                              ),

                      ],
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
                  backgroundColor: (ref.read(userDataProvider).dcp == null ||
                          ref.read(userDataProvider).dcp!.isEmpty)
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
                  (ref.read(userDataProvider).dcp == null ||
                          ref.read(userDataProvider).dcp!.isEmpty)
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
      height: size.height - 350,
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

class WaterEffect extends StatefulWidget {
  double progress;
  WaterEffect({required this.progress, Key? key}) : super(key: key);

  @override
  _WaterEffectState createState() => _WaterEffectState();
}

class _WaterEffectState extends State<WaterEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter:
            WaterPainter(animation: _controller, progress: widget.progress),
        child: Container(),
      ),
    );
  }
}

class WaterPainter extends CustomPainter {
  final Animation<double> animation;
  final double progress;

  WaterPainter({required this.animation, required this.progress})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final waterLevel = size.height * progress;
    final RRect container = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(20),
    );

    final path = Path()..addRRect(container);

    final pathWater = Path();
    pathWater.moveTo(0, size.height);
    pathWater.lineTo(0, size.height - waterLevel);

    final double waveHeight = 10.0;
    final double waveLength = size.width / 2;

    for (double i = 0; i <= size.width; i++) {
      final yOffset = waveHeight * sin((i / waveLength * 2 * pi) + (animation.value * 2 * pi));
      pathWater.lineTo(i, size.height - waterLevel + yOffset);
    }

    pathWater.lineTo(size.width, size.height);
    pathWater.close();

    final paintWater = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colorPrimaryDark, Colors.pinkAccent.withOpacity(0.3)],
      ).createShader(Rect.fromLTWH(0, size.height - waterLevel, size.width, waterLevel));

    final paintContainer = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, paintContainer);
    canvas.clipPath(path);
    canvas.drawPath(pathWater, paintWater);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this ||
        (oldDelegate as WaterPainter).progress != progress;
  }
}
