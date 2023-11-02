import 'dart:math';
import 'package:bandhu/constant/data.dart';
import 'package:bandhu/model/ask_give_model.dart';
import 'package:bandhu/screens/widget/home/calendar_card_widget.dart';
import 'package:bandhu/screens/widget/home/listview_card_widget.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class UserAskGiveScreen extends ConsumerStatefulWidget {
  const UserAskGiveScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAskGiveScreenState();
}

class _UserAskGiveScreenState extends ConsumerState<UserAskGiveScreen> {
  DateTime selectedDate = DateTime.now();
  int selectedyear = DateTime.now().year;

  Future<void> selectDate() async {
    showMonthPicker(
      selectedMonthBackgroundColor: colorPrimary,
      unselectedMonthTextColor: black,
      headerColor: colorPrimaryDark,
      context: context,
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
        });
      }
    });
  }

  List<Color> colors = [
    Colors.red.shade700,
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.yellow.shade700,
    Colors.purple.shade700,
  ];
  onPressBack() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: onPressBack,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: InkWell(
            onTap: selectDate,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "${DateFormat('MMM').format(selectedDate)} - ${selectedDate.year}",
                    style: fontSemiBold14.copyWith(color: black)),
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
          centerTitle: true,
          bottom: TabBar(
            padding: const EdgeInsets.all(0),
            tabs: const [
              Tab(
                  icon: Icon(Icons.calendar_month_outlined),
                  child: Text(
                    "Calendar View",
                  )),
              Tab(
                  icon: Icon(Icons.list_alt_rounded),
                  child: Text(
                    "List View",
                  )),
            ],
            labelColor: colorPrimary,
            unselectedLabelStyle: fontSemiBold10,
            labelStyle: fontSemiBold12,
            unselectedLabelColor: black,
            indicatorColor: colorPrimary,
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              "assets/images/bg.png",
              width: width,
              fit: BoxFit.fill,
            ),
            TabBarView(
              children: [
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.2 / 1, crossAxisCount: 2),
                  shrinkWrap: true,
                  itemCount: gridCardData.length,
                  itemBuilder: (context, index) => Card(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(20),
                    child: CalendarCard(
                        cardColor: colors[Random().nextInt(colors.length)],
                        count:
                            gridCardData[index]["askAndGiveCount"].toString(),
                        date: DateTime.parse(
                            gridCardData[index]["date"].toString())),
                  ),
                ),
                ListView.builder(
                    itemCount: listCardData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListViewCard(
                          cardData: AskGiveModel.fromMap(listCardData[index]),
                        ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
