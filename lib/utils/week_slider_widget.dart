import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeekSlider extends ConsumerWidget {
  final List data;
  final StateProvider<int> selectedWeekProvider;
  final Function refresh;
  const WeekSlider(
      {super.key,
      required this.data,
      required this.selectedWeekProvider,
      required this.refresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget weekSlider(
        {required String label,
        required int value,
        required int selectedValue,
        required WidgetRef ref}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedValue != value ? Colors.grey : colorAccent,
              foregroundColor: Colors.white),
          onPressed: () {
            ref.watch(selectedWeekProvider.notifier).state = value;
            refresh();
          },
          child: Text(
            label,
            style: fontSemiBold16,
          ),
        ),
      );
    }

    int selectedWeek = ref.watch(selectedWeekProvider);
    double width = MediaQuery.of(context).size.width;
    List weekList = [1, 2, 3, 4];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: width,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: weekList.map((week) {
          return weekSlider(
            label: week.toString(),
            value: week,
            selectedValue: selectedWeek,
            ref: ref,
          );
        }).toList(),
      ),
    );
  }
}
