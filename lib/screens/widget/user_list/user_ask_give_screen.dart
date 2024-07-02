import 'package:bandhu/api/ask_give_api.dart';
import 'package:bandhu/model/ask_give_model.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/screens/widget/home/calendar_card_widget.dart';
import 'package:bandhu/screens/widget/home/listview_card_widget.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class UserAskGiveScreen extends ConsumerStatefulWidget {
  final User userdata;
  const UserAskGiveScreen({super.key, required this.userdata});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAskGiveScreenState();
}

class _UserAskGiveScreenState extends ConsumerState<UserAskGiveScreen> {
  final userSelectedWeekProvider = StateProvider((ref) {
    DateTime date = DateTime.now();
    int firstDayOfMonthWeekday = DateTime(date.year, date.month, 1).weekday;
    int adjustedDayOfMonth = date.day + firstDayOfMonthWeekday - 1;
    return (adjustedDayOfMonth / 7).ceil();
  });
  final userSelectedDateTimeProvider = StateProvider((ref) => DateTime.now());
  final loader = StateProvider((ref) => true);
  final userListViewDataProvider = StateProvider(
    (ref) => [],
  );

  final gridViewDataProvider = StateProvider(
    (ref) => [],
  );

  Future<void> selectDate() async {
    showMonthPicker(
      selectedMonthBackgroundColor: colorPrimary,
      unselectedMonthTextColor: black,
      headerColor: colorPrimaryDark,
      context: context,
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        ref.watch(userSelectedDateTimeProvider.notifier).state = date;
        refresh();
      }
    });
  }

  onPressBack() => Navigator.pop(context);

  refresh() async {
    ref.watch(loader.notifier).state = true;
    ref.watch(userListViewDataProvider.notifier).state = await AskGive()
        .getAskGive(
            id: widget.userdata.id.toString(),
            month: ref.read(userSelectedDateTimeProvider).toUtc().toString());
    ref.watch(gridViewDataProvider.notifier).state = await AskGive()
        .getAskGiveByMonth(
            id: widget.userdata.id.toString(),
            month: ref.read(userSelectedDateTimeProvider).toUtc().toString());
    ref.watch(loader.notifier).state = false;
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () async => refresh());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List listCardData = ref.watch(userListViewDataProvider);
    List gridCardData = ref.watch(gridViewDataProvider);
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
                    "${DateFormat('MMM').format(ref.watch(userSelectedDateTimeProvider))} - ${ref.watch(userSelectedDateTimeProvider).year}",
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
                ref.watch(loader)
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.2 / 1, crossAxisCount: 2),
                        shrinkWrap: true,
                        itemCount: gridCardData.length,
                        itemBuilder: (context, index) => CalendarCard(
                            cardColor: colorAccentCard,
                            count: gridCardData[index]["length"].toString(),
                            date: DateTime.parse(
                                gridCardData[index]["date"].toString())),
                      ),
                ref.watch(loader)
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: listCardData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListViewCard(
                              cardData:
                                  AskGiveModel.fromJson(listCardData[index]),
                            ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
