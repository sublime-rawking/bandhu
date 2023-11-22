import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/model/ask_give_model.dart';
import 'package:bandhu/screens/widget/home/calendar_card_widget.dart';
import 'package:bandhu/screens/widget/home/listview_card_widget.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onPressLogOut() async => await Auth().logOut(context: context, ref: ref);
    double width = MediaQuery.of(context).size.width;

    AsyncValue<List<dynamic>> listViewData = ref.watch(listViewDataProvider);
    AsyncValue<List<dynamic>> gridViewData = ref.watch(gridViewDataProvider);
    DateTime selectedDate = ref.watch(selectedDateTimeProvider);

    refresh() async {
      listViewData = ref.refresh(listViewDataProvider);
      gridViewData = ref.refresh(gridViewDataProvider);
      return true;
    }

    Future<void> selectDate() async {
      showMonthPicker(
        selectedMonthBackgroundColor: colorPrimary,
        unselectedMonthTextColor: black,
        headerColor: colorPrimaryDark,
        context: context,
        initialDate: DateTime.now(),
      ).then((date) {
        if (date != null) {
          ref.watch(selectedDateTimeProvider.notifier).state = date;
          refresh();
        }
      });
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: onPressLogOut,
                icon: Icon(
                  Icons.logout_outlined,
                  color: colorPrimary,
                ),
              ),
            )
          ],
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
                gridViewData.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, stack) =>
                      const Text('Error: Something Went Wrong'),
                  data: (data) => GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2 / 1, crossAxisCount: 2),
                    shrinkWrap: true,
                    itemCount: data.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) => CalendarCard(
                        cardColor: colorAccentCard,
                        count: data[index]["task_count"].toString(),
                        date: DateTime.parse(
                            data[index]["list"][0]["date"].toString())),
                  ),
                ),
                listViewData.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, stack) =>
                      const Text('Error: Something Went Wrong'),
                  data: (data) => RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      itemCount: data.length,
                      reverse: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListViewCard(
                        cardData: AskGiveModel.fromMap(data[index]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
