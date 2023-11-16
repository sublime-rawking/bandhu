import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/screens/authscreen/forgetpassword.dart';
import 'package:bandhu/screens/authscreen/signup.dart';
import 'package:bandhu/screens/navbar/navbar.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final isObscuredProvider = StateProvider((ref) => true);
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loaderProvider = StateProvider((ref) => false);
  bool validatePhoneNumber() {
    final phoneNumber = phoneNumberController.text;
    return phoneNumber.isEmpty || phoneNumber.length != 10;
  }

  onPressSignIn() async {
    // check all fleids have value

    if (validatePhoneNumber()) {
      Fluttertoast.showToast(
        msg: "Mobile no cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: Colors.white,
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Password cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: Colors.white,
      );
      return;
    }

    ref.watch(loaderProvider.notifier).state = true;
    await Auth().signIn(authData: {
      "credential": phoneNumberController.text.trim(),
      "password": passwordController.text.trim()
    }, ref: ref, context: context).then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (c) => const Navbar()),
            (route) => false);
      } else {
        ref.watch(loaderProvider.notifier).state = false;
      }
    });
  }

  // navigate to forget password screen
  onPressForgetPassword() => openSendForgetPassword(context: context);

  // navigate to signup screen
  onPressSignUp() => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        ),
        (route) => false,
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isObscured = ref.watch(isObscuredProvider);
    Size size = MediaQuery.of(context).size;
    if (ref.watch(loaderProvider)) {
      Future.delayed(
          const Duration(seconds: 20),
          () => mounted
              ? ref.watch(loaderProvider.notifier).state = false
              : null);
    }
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/back_image.png",
              // height: 200,
              width: size.width,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Hello!\nWelcome to Bandhu Chapter",
              textAlign: TextAlign.center,
              style: fontSemiBold20.copyWith(color: colorAccentLight),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
              child: TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter Mobile No.",
                  errorText: validatePhoneNumber() &&
                          phoneNumberController.text.isNotEmpty
                      ? 'Invalid phone number'
                      : null,
                ),
                onChanged: (value) => setState(() {
                  validatePhoneNumber();
                }),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => ref
                        .watch(isObscuredProvider.notifier)
                        .state = !isObscured,
                  ),
                ),
                obscureText: isObscured,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextButton(
                  onPressed: onPressForgetPassword,
                  child: Text(
                    "Forgot Password?",
                    style: fontRegular12.copyWith(color: colorAccentLight),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: ref.watch(loaderProvider) ? null : onPressSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                fixedSize: Size(size.width - 60, 50),
              ),
              child: ref.watch(loaderProvider)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: white,
                      ),
                    )
                  : Text(
                      "Sign in",
                      style: fontMedium14,
                    ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: onPressSignUp,
              child: RichText(
                text: TextSpan(
                  text: 'New to Bandhu Chapter?\t\t',
                  style: fontRegular14.copyWith(color: label),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Sign up',
                        style: fontRegular14.copyWith(color: colorPrimary)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
