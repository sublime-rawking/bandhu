// ignore_for_file: use_build_context_synchronously

import 'package:bandhu/api/ask_give_api.dart';
import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AskGivePopup extends ConsumerStatefulWidget {
  const AskGivePopup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AskGivePopupState();
}

class _AskGivePopupState extends ConsumerState<AskGivePopup> {
  final TextEditingController _askController = TextEditingController();
  final TextEditingController _giveController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  DateTime selectedDate = DateTime.now();

  onPressClose() => Navigator.pop(context);
  onPressCalendar() async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(selectedDate.year, selectedDate.month),
      lastDate: DateTime(selectedDate.year, selectedDate.month + 1)
          .subtract(const Duration(days: 1)),
    );
    if (pickedDate != null) {
      selectedDate = pickedDate;
    }
    setState(() {});
  }

  onPressSend() async {
    if (_askController.text.isEmpty ||
        _giveController.text.isEmpty ||
        _remarkController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill-in all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    Map<String, dynamic> askGiveData = {
      "member_id": ref.read(userDataProvider).userid,
      "date": "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      "ask": _askController.text,
      "given": _giveController.text,
      "remark": _remarkController.text,
    };
    await AskGive().addAskGive(askGiveData: askGiveData).then((value) async {
      await Auth().getUserData(ref: ref, context: context);
      // ignore: unused_result
      ref.refresh(listViewDataProvider);
      // ignore: unused_result
      ref.refresh(gridViewDataProvider);
      if (value) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Add",
                    style: fontSemiBold16.copyWith(color: colorPrimary),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onPressClose,
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: onPressCalendar,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "${selectedDate.day}-${DateFormat('MMM').format(selectedDate)}-${selectedDate.year}",
                          style: fontMedium14.copyWith(color: black)),
                      const SizedBox(
                        width: 10,
                      ),
                      const RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: TextField(
                  controller: _askController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxHeight: 100),
                    labelText: 'Ask',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: TextField(
                  controller: _giveController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxHeight: 100),
                    labelText: 'Give',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: TextField(
                  controller: _remarkController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    constraints: BoxConstraints(maxHeight: 100),
                    labelText: 'Remark',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: colorPrimary,
                ),
                onPressed: onPressSend,
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
