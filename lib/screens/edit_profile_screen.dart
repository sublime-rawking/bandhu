import 'dart:io';
import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/provider/image_provider.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/imagebottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _selectedImageProvider = StateProvider((ref) => "");
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  onPressBack() => Navigator.pop(context);
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

  onPressUpdate() async {
    // check all  text fields are field
    if (fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name field can not be empty"),
        ),
      );
      return;
    } else if (emailController.text.isEmpty || validateEmail()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email field can not be empty"),
        ),
      );
      return;
    } else if (validatePhoneNumber()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Phone number field can not be empty"),
        ),
      );
      return;
    }

    // get all the fields in Map Object
    Map<String, String> userData = {
      "id": ref.read(userDataProvider).userid,
      "Name": fullNameController.text
    };
    if (ref.read(userDataProvider).email != emailController.text) {
      userData["email"] = emailController.text;
    }
    if (ref.read(userDataProvider).phone != phoneNumberController.text) {
      userData["Mobile"] = phoneNumberController.text;
    }

    if (ref.read(_selectedImageProvider).isNotEmpty) {
      userData["Profile"] = ref.read(_selectedImageProvider).toString();
    }

    try {
      await Auth()
          .updateUser(userData: userData, ref: ref, context: context)
          .then((value) {
        if (!value) {
          return;
        }

        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Profile updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: Colors.white,
        );
      });
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

  getUserData() async {
    emailController.text = ref.read(userDataProvider).email;
    fullNameController.text = ref.read(userDataProvider).name;
    phoneNumberController.text = ref.read(userDataProvider).phone;
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final selectedImage = ref.watch(_selectedImageProvider);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/backimg_register.png"))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Text(
                      "Edit Profile",
                      textAlign: TextAlign.left,
                      style: fontSemiBold20.copyWith(color: white),
                    ),
                  ),
                  // Display the selected image
                  InkWell(
                      onTap: oncallBottomSheet,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors
                                  .grey, // Replace with your desired shadow color
                              offset: Offset(0,
                                  2), // Replace with your desired shadow offset
                              blurRadius:
                                  4, // Replace with your desired blur radius
                            ),
                          ],
                        ),
                        child: selectedImage != ""
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                foregroundImage: FileImage(File(selectedImage)),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                foregroundImage: NetworkImage(
                                    "$baseUrl/${ref.read(userDataProvider).image}"),
                              ),
                      )),
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

                  ElevatedButton(
                    onPressed: onPressUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      fixedSize: Size(size.width - 60, 50),
                    ),
                    child: Text(
                      "Update Profile",
                      style: fontMedium14,
                    ),
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: onPressBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimary,
                      fixedSize: Size(size.width - 60, 50),
                    ),
                    child: Text(
                      "Go Back",
                      style: fontMedium14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
