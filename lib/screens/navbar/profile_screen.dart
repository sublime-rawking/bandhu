import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/screens/authscreen/forgetpassword.dart';
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
  onPressLogout() async => await Auth().logOut(context: context, ref: ref);
  // navigate to forget password screen

  onPressForgetPassword() => openSendForgetPassword(context: context);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: white,
      body: RefreshIndicator(
        onRefresh: () async {
          await Auth().getUserData(ref: ref);
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset("assets/images/backimg_register.png"),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              foregroundImage:
                                  NetworkImage("$baseUrl/${userData.image}"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              userData.name,
                              style: fontSemiBold16,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: width / 2 - 80,
                                child: Column(
                                  children: [
                                    Text(
                                      "Total Give and Ask",
                                      style: fontSemiBold16,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      userData.askGiveCount.toString(),
                                      style: fontMedium16,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: width / 2 - 80,
                                child: Column(
                                  children: [
                                    Text(
                                      "DCP uploaded",
                                      style: fontSemiBold16,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      userData.dcp.isNotEmpty ? "Yes" : "No",
                                      style: fontMedium16,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "User Id.: ${userData.userid}",
                          style: fontSemiBold14,
                        ),
                        Text(
                          "Mobile No.: ${userData.phone}",
                          style: fontSemiBold14,
                        ),
                        Text(
                          "Email: ${userData.email}",
                          style: fontSemiBold14,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextButton(
                            onPressed: onPressForgetPassword,
                            child: Text(
                              "Forget Password?",
                              style:
                                  fontSemiBold14.copyWith(color: colorPrimary),
                            )),
                        ElevatedButton(
                          onPressed: onPressLogout,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              fixedSize: Size(width, 60)),
                          child: Text(
                            "Logout",
                            style: fontSemiBold14.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
