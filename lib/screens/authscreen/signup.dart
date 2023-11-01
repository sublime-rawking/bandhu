import 'dart:io';

import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/provider/image_provider.dart';
import 'package:bandhu/screens/authscreen/login.dart';
import 'package:bandhu/screens/navbar/navbar.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/imagebottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _selectedImageProvider = StateProvider((ref) => "");
  final isObscuredProvider = StateProvider((ref) => true);
  final isConObscuredProvider = StateProvider((ref) => true);
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  bool validatePhoneNumber() {
    final phoneNumber = phoneNumberController.text;
    if (phoneNumber.isEmpty) {
      return true;
    }
    return phoneNumber.length != 10;
  }

  // email validation
  bool validateEmail() {
    String email = emailController.text;
    if (email.isEmpty) {
      return true;
    }
    bool isValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
    return !isValid;
  }

  // set image to userprofileImage
  void storeProfileImage(filePath) {
    ref.watch(_selectedImageProvider.notifier).state = filePath;
  }

  /// Executes when the camera button is pressed
  onPressCamera() async {
    Navigator.pop(context); // Close the current screen
    await takeImages(
      storeImage: (cropFile) => storeProfileImage(cropFile),
      source: ImageSource.camera,
    ); // Call the takeImages function with the camera as the image source
  }

  /// Executes when the gallery button is pressed
  onPressGallery() async {
    Navigator.pop(context); // Close the current screen
    await takeImages(
        storeImage: (filePath) => storeProfileImage(filePath),
        source: ImageSource
            .gallery); // Call the takeImages function with the gallery as the image source
  }

  /// Executes when the delete button is pressed
  onPressDelete() async {
    Navigator.pop(context); // Close the current screen
    ref.watch(_selectedImageProvider.notifier).state =
        ''; // Set the userprofileImage state to an empty string
  }

  oncallBottomSheet() => bottomSheet(
      selected: ref.watch(_selectedImageProvider).toString() != "",
      context: context,
      cameraBtn: onPressCamera,
      galleryBtn: onPressGallery,
      deleteBtn: onPressDelete);

  onPressSignUp() async {
    // check all  text fields are field
    if (fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your full name"),
        ),
      );
      return;
    } else if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your email"),
        ),
      );
      return;
    } else if (phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your phone number"),
        ),
      );
      return;
    } else if (passwordController.text.isEmpty ||
        conPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your password properly"),
        ),
      );
      return;
    }

    if (passwordController.text != conPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    // get all the fields in Map Object
    Map<String, String> userData = {
      "name": fullNameController.text,
      "email": emailController.text,
      "mobileNo": phoneNumberController.text,
      "password": passwordController.text,
      "image": ref.watch(_selectedImageProvider).toString() != ""
          ? ref.watch(_selectedImageProvider).toString()
          : "",
    };
    try {
      await Auth().signUp(userData: userData, ref: ref).then((value) => value
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => const Navbar()),
              (route) => false)
          : null);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: Colors.white,
      );
    }
  }

  onPressSignIn() => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );

  @override
  Widget build(BuildContext context) {
    final isObscured = ref.watch(isObscuredProvider);
    final isConObscured = ref.watch(isConObscuredProvider);
    Size size = MediaQuery.of(context).size;

    final selectedImage = ref.watch(_selectedImageProvider);
    return Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset("assets/images/backimg_register.png"),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Text(
                          "Hello!\nSign up to get Started.",
                          textAlign: TextAlign.center,
                          style: fontSemiBold20.copyWith(color: white),
                        ),
                      ),
                      // Display the selected image
                      InkWell(
                        onTap: oncallBottomSheet,
                        child: selectedImage != ""
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                foregroundImage: FileImage(File(selectedImage)),
                              )
                            : const CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                foregroundImage:
                                    AssetImage(defaultprofileImage),
                              ),
                      ),
                      const SizedBox(height: 60),
                      TextField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          hintText: "Enter Full Name",
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          errorText:
                              validateEmail() && emailController.text.isNotEmpty
                                  ? 'Invalid email'
                                  : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            validateEmail();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter Mobile No.",
                          errorText: validatePhoneNumber() &&
                                  phoneNumberController.text.isNotEmpty
                              ? 'Invalid phone number'
                              : null,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          setState(() {
                            validatePhoneNumber();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Enter Your Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => ref
                                .watch(isObscuredProvider.notifier)
                                .state = !isObscured,
                          ),
                        ),
                        obscureText: isObscured,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: conPasswordController,
                        decoration: InputDecoration(
                          hintText: "Comfirm Your Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => ref
                                .watch(isConObscuredProvider.notifier)
                                .state = !isConObscured,
                          ),
                        ),
                        obscureText: isConObscured,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: onPressSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          fixedSize: Size(size.width - 60, 50),
                        ),
                        child: Text(
                          "Sign up",
                          style: fontMedium14,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: onPressSignIn,
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account?\t\t',
                            style: fontRegular14.copyWith(color: label),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign in',
                                  style: fontRegular14.copyWith(
                                      color: colorPrimary)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
