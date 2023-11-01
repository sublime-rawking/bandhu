import 'package:bandhu/constant/data.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/screens/widget/user_list/user_list_card_widget.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User List",
          style: fontSemiBold16.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bg.png",
              width: size.width,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(
                    height: size.height - 200,
                    child: ListView.builder(
                      itemCount: personCardData.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) => Column(
                        children: [
                          UserListCardWidget(
                            userData: User.fromMap(personCardData[index]),
                          ),
                          index != personCardData.length
                              ? const Divider()
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
