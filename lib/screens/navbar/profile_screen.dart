import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/images/backimg_register.png"),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      foregroundImage: AssetImage(defaultprofileImage),
                    ),
                  ),
                  Text(
                    "Name: UserName",
                    style: fontSemiBold14,
                  ),
                  Text(
                    "Mobile No.: 1231242352",
                    style: fontSemiBold14,
                  ),
                  Text(
                    "Email: abc@abc.com",
                    style: fontSemiBold14,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
