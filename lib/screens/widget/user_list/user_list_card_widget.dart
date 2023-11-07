import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/screens/widget/user_list/user_ask_give_screen.dart';
import 'package:bandhu/screens/widget/user_list/user_profile_pdf_screen.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListCardWidget extends ConsumerWidget {
  final User userData;
  const UserListCardWidget({super.key, required this.userData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    onPressCard() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserAskGiveScreen(
                  userdata: userData,
                )));

    onPressOpenPDF() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFScreen(
                dcpPDF: userData.dcp != ""
                    ? '$baseUrl/uploads/dcp/${userData.dcp}'
                    : "")));
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onPressCard,
        child: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                foregroundImage: NetworkImage("$baseUrl/${userData.image}")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      userData.name,
                      style: fontMedium14.copyWith(color: Colors.black),
                    ),
                    Text(
                      userData.phone,
                      style: fontRegular14.copyWith(color: Colors.black),
                    )
                  ]),
            ),
            const Spacer(),
            userData.dcp != ""
                ? IconButton(
                    onPressed: onPressOpenPDF,
                    icon: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: colorPrimary,
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
