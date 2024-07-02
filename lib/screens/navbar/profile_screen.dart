import 'package:bandhu/provider/auth_services.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/screens/authscreen/forgetpassword.dart';
import 'package:bandhu/screens/edit_profile_screen.dart';
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
  onPressLogout() async =>
      await Auth.instance.logOut(context: context, ref: ref);
  onPressEditProfile() async => Navigator.push(
      context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));

  // navigate to forget password screen
  onPressForgetPassword() => openSendForgetPassword(
      context: context,
      title: "Change Password",
      email: ref.read(AuthServices.instance.userDataProvider).email.toString());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final userData = ref.watch(AuthServices.instance.userDataProvider);

    onPressProfile() => showImageViewer(
            context, Image.network("$baseUrl}/${userData.profileImage}").image,
            onViewerDismissed: () {
          print(userData.profileImage);
        });

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/backimg_register.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: () async {
             await Auth.instance.getUserData(ref: ref, context: context);
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: (userData.profileImage != null &&
                                userData.profileImage!.isNotEmpty)
                            ? onPressProfile
                            : null,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network("$baseUrl/${userData.profileImage}",
                            loadingBuilder: (context, child, loadingProgress) {
                              return CircularProgressIndicator();
                            },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/images/default.png");
                              },
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        userData.name.toString(),
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
                                userData.giveAsk.toString(),
                                style: fontMedium16,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                (userData.dcp != null &&
                                        userData.dcp!.isNotEmpty)
                                    ? "Yes"
                                    : "No",
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
                    "User Id.: ${userData.id}",
                    style: fontSemiBold14,
                  ),
                  Text(
                    "Mobile No.: ${userData.mobile}",
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
                        "Change Password?",
                        style: fontSemiBold14.copyWith(color: colorPrimary),
                      )),
                  ElevatedButton(
                    onPressed: onPressEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      fixedSize: Size(width, 50),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: fontSemiBold14.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: onPressLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      fixedSize: Size(width, 50),
                    ),
                    child: Text(
                      "Logout",
                      style: fontSemiBold14.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
