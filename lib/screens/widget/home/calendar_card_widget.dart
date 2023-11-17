import 'package:bandhu/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarCard extends ConsumerWidget {
  final DateTime date;
  final String count;
  final Color cardColor;
  const CalendarCard({
    super.key,
    required this.date,
    required this.cardColor,
    required this.count,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formatDate = DateFormat('dd-MM-yyyy').format(date);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate,
            style: fontMedium14.copyWith(color: Colors.black),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Total\nAsk and Give",
                style: fontSemiBold12.copyWith(color: Colors.black),
              ),
              const Spacer(),
              Text(
                count,
                style:
                    fontSemiBold16.copyWith(fontSize: 26, color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }
}
