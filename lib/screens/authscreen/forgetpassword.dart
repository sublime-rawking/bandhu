import 'package:bandhu/api/auth_api.dart';
import 'package:bandhu/theme/fonts.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/reset_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void openSendForgetPassword(
        {required BuildContext context,
        String title = "Forgot Password",
        String email = ""}) =>
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SendForgetPasswordRequest(title: title, email: email);
      },
    );

class SendForgetPasswordRequest extends ConsumerStatefulWidget {
  final String title, email;
  const SendForgetPasswordRequest(
      {super.key, required this.title, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendForgetPasswordRequestState();
}

class _SendForgetPasswordRequestState
    extends ConsumerState<SendForgetPasswordRequest> {
  final TextEditingController emailController = TextEditingController();
  final loader = StateProvider((ref) => false);
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

  onPressClose() => Navigator.pop(context);
  onPressSend() async {
    ref.watch(loader.notifier).state = true;
    if (validateEmail()) {
      Fluttertoast.showToast(
        msg: emailController.text.trim().isEmpty
            ? 'Email cannot be empty'
            : 'Invalid email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      ref.watch(loader.notifier).state = false;
      return;
    }

    await Auth().forgetPassword(email: emailController.text).then((res) {
      ref.watch(loader.notifier).state = false;
      if (!res) {
        return;
      }

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => ResetPassword(
            email: emailController.text,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.email.isNotEmpty) {
      setState(() {
        emailController.text = widget.email;
      });
    }
    double width = MediaQuery.of(context).size.width;
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: fontSemiBold14.copyWith(color: colorAccent),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: emailController,
                  readOnly: widget.email.isNotEmpty,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            fixedSize: Size(width / 3, 50)),
                        onPressed: onPressSend,
                        child: const Text("Send")),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorAccent),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          fixedSize: Size(width / 3, 50)),
                      onPressed: onPressClose,
                      child: const Text("Close"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class ResetPassword extends ConsumerStatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final isObscuredProvider = StateProvider((ref) => true);
  final isConObscuredProvider = StateProvider((ref) => true);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();
  final TextEditingController otpContollerProvider = TextEditingController();

  onPressSubmit() async {
    if (otpContollerProvider.text.isEmpty ||
        otpContollerProvider.text.length < 6) {
      Fluttertoast.showToast(
        msg: otpContollerProvider.text.length < 6 &&
                otpContollerProvider.text.isNotEmpty
            ? 'Please enter OTP properly'
            : 'Please enter OTP',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return;
    }
    if (conPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter confirm password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return;
    }
    if (passwordController.text != conPasswordController.text) {
      Fluttertoast.showToast(
        msg: 'Password does not match',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return;
    }

    await Auth()
        .verifyOTP(
            email: widget.email,
            otp: otpContollerProvider.text,
            password: passwordController.text)
        .then((value) {
      if (!value["success"]) {
        showDialog(
            context: context,
            builder: (_) => ResetPasswordDialog(
                  msg: value["status"],
                  status: false,
                ));
        return;
      }
      showDialog(
          context: context,
          builder: (_) => const ResetPasswordDialog(
                msg: 'Password changed successfully',
                status: true,
              ));
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }

  onPressBack() => Navigator.pop(context);
  FocusNode myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isObscured = ref.watch(isObscuredProvider);
    final isConObscured = ref.watch(isConObscuredProvider);
    final defaultPinTheme = PinTheme(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: size.width,
      height: 60,
      textStyle: fontSemiBold20.copyWith(
        color: const Color(0xFF1F1F1F),
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: colorPrimary),
        color: const Color.fromARGB(136, 232, 235, 241),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60, bottom: 40),
                          child: Text(
                            "Verify your OTP",
                            textAlign: TextAlign.left,
                            style: fontSemiBold20.copyWith(color: black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'Enter your OTP',
                            style: fontMedium14.copyWith(
                              color: const Color.fromARGB(255, 68, 68, 68),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Pinput(
                            controller: otpContollerProvider,
                            length: 6,
                            focusNode: myFocusNode,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: colorPrimaryDark),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            // onCompleted: (pin) => print(pin),
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintStyle: fontMedium14.copyWith(
                              color: const Color.fromARGB(255, 68, 68, 68),
                            ),
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
                        const SizedBox(height: 30),
                        TextField(
                          controller: conPasswordController,
                          decoration: InputDecoration(
                            hintText: "Comfirm Your Password",
                            hintStyle: fontMedium14.copyWith(
                              color: const Color.fromARGB(255, 68, 68, 68),
                            ),
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
                          onPressed: onPressSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            fixedSize: Size(size.width - 60, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            "Change password",
                            style: fontSemiBold14,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        OutlinedButton(
                          onPressed: onPressBack,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorAccent),
                            fixedSize: Size(size.width - 60, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            "Back",
                            style: fontSemiBold14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
