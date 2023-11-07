import 'package:bandhu/model/ask_give_model.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ListViewCard extends ConsumerStatefulWidget {
  final AskGiveModel cardData;
  const ListViewCard({super.key, required this.cardData});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewCardState();
}

class _ListViewCardState extends ConsumerState<ListViewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorAccentCard,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Text(
            DateFormat("dd-MM-yyyy").format(widget.cardData.date),
            style: fontMedium16.copyWith(color: Colors.black),
          ),
          theme: ExpandableThemeData(
              hasIcon: widget.cardData.ask.length < 52 &&
                      widget.cardData.give.length < 52 &&
                      widget.cardData.remark.length < 45
                  ? false
                  : true,
              useInkWell: false),
          collapsed: dateFeild(
              askData: widget.cardData.ask,
              giveData: widget.cardData.give,
              isWrap: true,
              remarkData: widget.cardData.remark),
          expanded: dateFeild(
              askData: widget.cardData.ask,
              giveData: widget.cardData.give,
              isWrap: false,
              remarkData: widget.cardData.remark),
        ),
      ),
    );
  }
}

Widget dateFeild(
        {required String askData,
        required String giveData,
        required String remarkData,
        required bool isWrap}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          maxLines: isWrap ? 1 : null,
          text: TextSpan(
            text: 'Ask : ',
            style: fontSemiBold12.copyWith(color: Colors.black),
            children: [
              TextSpan(
                text: askData,
                style: fontMedium12.copyWith(
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          softWrap: true,
        ),
        const SizedBox(height: 10), // Add a SizedBox here with a height
        RichText(
          maxLines: isWrap ? 1 : null,
          text: TextSpan(
            text: 'Give : ',
            style: fontSemiBold12.copyWith(color: Colors.black),
            children: [
              TextSpan(
                text: giveData,
                style: fontMedium12.copyWith(
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          softWrap: true,
        ),
        const SizedBox(height: 10), // Add a SizedBox here with a height
        RichText(
          maxLines: isWrap ? 1 : null,
          text: TextSpan(
            text: 'Remark : ',
            style: fontSemiBold12.copyWith(color: Colors.black),
            children: [
              TextSpan(
                text: remarkData,
                style: fontMedium12.copyWith(
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          softWrap: true,
        ),
      ],
    );
